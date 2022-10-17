import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:open_location_picker/open_location_picker.dart';
import 'package:pomagacze/db/db.dart';
import 'package:pomagacze/models/help_event.dart';
import 'package:pomagacze/pages/event_details.dart';
import 'package:pomagacze/state/events.dart';
import 'package:pomagacze/utils/constants.dart';
import 'package:pomagacze/utils/location_utils.dart';
import 'package:pomagacze/utils/snackbar.dart';

class EventForm extends ConsumerStatefulWidget {
  final HelpEvent? initialData;

  const EventForm({Key? key, this.initialData}) : super(key: key);

  @override
  EventFormState createState() => EventFormState();
}

class EventFormState extends ConsumerState<EventForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  bool _loading = false;

  FormattedLocation? _location;

  XFile? _imageFile;

  bool get isEditing => widget.initialData != null;

  @override
  void initState() {
    super.initState();
    if (widget.initialData?.longitude != null) {
      _location = FormattedLocation.fromLatLng(
          lat: widget.initialData!.latitude ?? 0,
          lon: widget.initialData!.longitude ?? 0,
          displayName: widget.initialData!.addressFull);

      reverseLocation(
              locale: const Locale('pl'),
              location: LatLng(widget.initialData!.latitude ?? 0,
                  widget.initialData!.longitude ?? 0))
          .then((value) {
        if (mounted) {
          setState(() {
            _location = value;
          });
        }
      });
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.saveAndValidate()) {
      context.showErrorSnackBar(message: 'Nie wszystkie pola są poprawne!');
      return;
    }

    setState(() {
      _loading = true;
    });

    String? imageUrl;
    if (_imageFile != null) {
      final bytes = await _imageFile!.readAsBytes();
      final fileExt = _imageFile!.path.split('.').last;
      final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
      final filePath = fileName;
      final response = await supabase.storage
          .from('event-images')
          .uploadBinary(filePath, bytes);
      if (response.error != null && mounted) {
        context.showErrorSnackBar(message: response.error!.message);
        return;
      }
      imageUrl = (supabase.storage.from('event-images').getPublicUrl(filePath)).data;
    }

    final ageRange = _formKey.currentState!.value['age_range'] as RangeValues?;
    final volunteerCountRange = _formKey.currentState!.value['volunteer_count_range'] as RangeValues?;

    final values = {
      ...(widget.initialData?.toJson() ?? {}),
      ..._formKey.currentState!.value,
      'author_id': supabase.auth.currentUser?.id,
      'address_short': _location != null
          ? '${_location!.address.road}, ${_location!.address.city}'
          : '',
      'address_full': _location?.displayName,
      'latitude': _location?.lat,
      'longitude': _location?.lon,
      'minimal_age': ageRange?.start.round(),
      'maximal_age': ageRange?.end.round(),
      'minimal_number_of_volunteers': volunteerCountRange?.start.round(),
      'maximal_number_of_volunteers': volunteerCountRange?.end.round(),
      'points': (_formKey.currentState!.value['points'] as double).round(),
      'image_url': imageUrl ?? widget.initialData?.imageUrl
    };

    var data = HelpEvent.fromData(values);
    data = await EventsDB.upsert(data).catchError((err, stack) {
      print(err);
      print(stack);
      context.showErrorSnackBar(message: err.toString());
    });

    setState(() {
      _loading = false;
    });

    await ref.refresh(feedFutureProvider.future);
    await ref.refresh(eventFutureProvider(data.id!).future);


    if (mounted) {
      if (isEditing) {
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => EventDetails(data)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(isEditing ? 'Edytuj wydarzenie' : 'Nowe wydarzenie')),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Theme.of(context).colorScheme.secondary,
            foregroundColor: Theme.of(context).colorScheme.onSecondary,
            onPressed: _submit,
            label: Text(isEditing ? 'Zapisz' : 'Opublikuj'),
            icon: _loading
                ? Transform.scale(
                    scale: 0.6,
                    child: CircularProgressIndicator(color: Theme.of(context).colorScheme.onSecondary))
                : Icon(isEditing ? Icons.save : Icons.send)),
        body: FormBuilder(
          key: _formKey,
          initialValue: widget.initialData?.toJson() ?? {},
          child: Padding(
              padding: const EdgeInsets.all(15),
              child: ListView(
                  padding: const EdgeInsets.only(bottom: 100),
                  children: [
                    FormBuilderTextField(
                      name: 'title',
                      style: Theme.of(context).textTheme.titleLarge,
                      validator: FormBuilderValidators.required(
                          errorText: 'Tytuł nie może być pusty'),
                      decoration: const InputDecoration(labelText: 'Tytuł'),
                    ),
                    const SizedBox(height: 15),
                    FormBuilderTextField(
                      name: 'description',
                      minLines: 1,
                      // any number you need (It works as the rows for the textarea)
                      keyboardType: TextInputType.multiline,
                      maxLines: 8,
                      decoration: const InputDecoration(labelText: 'Opis', icon: Icon(Icons.text_snippet)),
                      validator: FormBuilderValidators.required(
                          errorText: 'Opis nie może być pusty'),
                    ),
                    const SizedBox(height: 15),
                    FormBuilderTextField(
                      name: 'image_url',
                      decoration: InputDecoration(
                          labelText: 'Zdjęcie',
                          icon: const Icon(Icons.photo),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _imageFile = null;
                              _formKey.currentState?.fields['image_url']
                                  ?.didChange(null);
                            },
                          )),
                      readOnly: true,
                      onTap: () async {
                        final picker = ImagePicker();
                        final imageFile = await picker.pickImage(
                          source: ImageSource.gallery,
                          maxWidth: 300,
                          maxHeight: 300,
                        );
                        if (imageFile == null) {
                          return;
                        }
                        _imageFile = imageFile;

                        _formKey.currentState?.fields['image_url']
                            ?.didChange(_imageFile?.name ?? '');
                      },
                    ),
                    const SizedBox(height: 15),
                    FormBuilderField<String>(
                      name: 'date_start',
                      initialValue:
                          (widget.initialData?.dateStart ?? DateTime.now())
                              .toString(),
                      builder: (field) {
                        return DateTimePicker(
                          type: DateTimePickerType.dateTimeSeparate,
                          key: Key(field.value.toString()),
                          dateMask: 'EE, dd MMM yyyy',
                          initialValue: field.value,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2500),
                          onChanged: (dateTimeString) {
                            var date = DateTime.tryParse(dateTimeString);
                            if (date == null) return;

                            field.didChange(dateTimeString);

                            var endDate = DateTime.tryParse(_formKey
                                .currentState!
                                .fields['date_end']
                                ?.value as String);

                            if (endDate != null && date.isAfter(endDate)) {
                              _formKey.currentState!.fields['date_end']
                                  ?.didChange(dateTimeString);
                            }
                          },
                          dateLabelText: 'Data rozpoczęcia',
                          timeLabelText: 'Godzina',
                          icon: const Icon(Icons.event),
                        );
                      },
                    ),
                    const SizedBox(height: 15),
                    FormBuilderField<String>(
                      name: 'date_end',
                      initialValue: (widget.initialData?.dateEnd ??
                              DateTime.now().add(const Duration(hours: 1)))
                          .toString(),
                      builder: (field) {
                        return DateTimePicker(
                          type: DateTimePickerType.dateTimeSeparate,
                          dateMask: 'EE, dd MMM yyyy',
                          initialValue: field.value.toString(),
                          key: Key(field.value.toString() +
                              _formKey
                                  .currentState?.fields['date_start']?.value),
                          firstDate: DateTime.tryParse(_formKey
                                  .currentState?.fields['date_start']?.value) ??
                              DateTime.now(),
                          lastDate: DateTime(2500),
                          onChanged: (dateTimeString) {
                            var date = DateTime.tryParse(dateTimeString);
                            if (date == null) return;

                            field.didChange(dateTimeString);

                            var startDate = DateTime.tryParse(_formKey
                                .currentState!
                                .fields['date_start']
                                ?.value ?? '');

                            if (startDate != null && date.isBefore(startDate)) {
                              _formKey.currentState!.fields['date_start']
                                  ?.didChange(dateTimeString);
                            }
                          },
                          dateLabelText: 'Data zakończenia',
                          timeLabelText: 'Godzina',
                          icon: const Icon(Icons.event, color: Colors.transparent),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    OpenMapPicker(
                      initialValue: _location,
                      options: OpenMapOptions(
                          center: LatLng(
                              widget.initialData?.latitude ?? wroclawLat,
                              widget.initialData?.longitude ?? wroclawLng)),
                      decoration: const InputDecoration(
                        labelText: "Lokalizacja",
                        prefixIconConstraints: BoxConstraints(maxWidth: 0),
                        prefixIcon: Icon(null),
                        icon: Icon(Icons.location_pin),
                      ),
                      removeIcon: Icon(Icons.clear,
                          color: Theme.of(context).colorScheme.onSurface),
                      onChanged: (FormattedLocation? newValue) {
                        _location = newValue;
                      },
                      validator: FormBuilderValidators.required(
                          errorText: "Lokalizacja nie może być pusta"),
                    ),
                    const SizedBox(height: 20),
                    FormBuilderSlider(
                      name: 'points',
                      initialValue: minimalPoints.toDouble(),
                      min: minimalPoints.toDouble(),
                      max: maximalPoints.toDouble(),
                      numberFormat: NumberFormat('###'),
                      decoration: const InputDecoration(labelText: 'Punkty za udział', icon: Icon(Icons.favorite)),
                    ),
                    const SizedBox(height: 20),
                    FormBuilderRangeSlider(
                      name: 'age_range',
                      decoration: const InputDecoration(
                          labelText: 'Wymagany wiek wolontariusza',
                          icon: Icon(Icons.face)),
                      min: minimalVolunteerAge.toDouble(),
                      max: maximalVolunteerAge.toDouble(),
                      divisions: maximalVolunteerAge - minimalVolunteerAge + 1,
                      initialValue: RangeValues(
                          widget.initialData?.minimalAge?.toDouble() ??
                              minimalVolunteerAge.toDouble(),
                          widget.initialData?.maximalAge?.toDouble() ??
                              maximalVolunteerAge.toDouble()),
                      numberFormat: NumberFormat('### lat'),
                    ),
                    const SizedBox(height: 20),
                    FormBuilderRangeSlider(
                      name: 'volunteer_count_range',
                      decoration: const InputDecoration(
                          labelText: 'Ilość wolontariuszy',
                          icon: Icon(Icons.people)),
                      min: minimalVolunteerCount.toDouble(),
                      max: maximalVolunteerCount.toDouble(),
                      divisions:
                          maximalVolunteerCount - minimalVolunteerCount + 1,
                      initialValue: RangeValues(
                          widget.initialData?.minimalNumberOfVolunteers
                                  ?.toDouble() ??
                              minimalVolunteerCount.toDouble(),
                          widget.initialData?.maximalNumberOfVolunteers
                                  ?.toDouble() ??
                              maximalVolunteerCount.toDouble()),
                      numberFormat: NumberFormat('###'),
                    ),
                    const SizedBox(height: 20),
                    FormBuilderTextField(
                      name: 'email',
                      decoration: const InputDecoration(labelText: 'Adres e-mail (opcjonalne)', icon: Icon(Icons.alternate_email)),
                    ),
                    const SizedBox(height: 20),
                  ])),
        ));
  }
}
