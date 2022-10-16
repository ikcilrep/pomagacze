import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
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

    final ageRange = _formKey.currentState!.value['age_range'] as RangeValues?;

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
      'points': (_formKey.currentState!.value['points'] as double).round()
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

    print(data);

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
            onPressed: _submit,
            label: Text(isEditing ? 'Zapisz' : 'Opublikuj'),
            icon: _loading
                ? Transform.scale(
                    scale: 0.6,
                    child: const CircularProgressIndicator(color: Colors.white))
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
                      decoration: const InputDecoration(labelText: 'Opis'),
                      validator: FormBuilderValidators.required(
                          errorText: 'Opis nie może być pusty'),
                    ),
                    const SizedBox(height: 15),
                    FormBuilderField(
                      name: 'date_start',
                      initialValue: DateTime.now().toString(),
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
                        );
                      },
                    ),
                    const SizedBox(height: 15),
                    FormBuilderField(
                      name: 'date_end',
                      initialValue: DateTime.now()
                          .add(const Duration(hours: 1))
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
                                ?.value as String);

                            if (startDate != null && date.isBefore(startDate)) {
                              _formKey.currentState!.fields['date_start']
                                  ?.didChange(dateTimeString);
                            }
                          },
                          dateLabelText: 'Data zakończenia',
                          timeLabelText: 'Godzina',
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
                        suffixIcon: Icon(Icons.location_pin),
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
                      decoration: const InputDecoration(labelText: 'Punkty'),
                    ),
                    const SizedBox(height: 20),
                    FormBuilderRangeSlider(
                      name: 'age_range',
                      decoration: const InputDecoration(
                          labelText: 'Wymagany wiek wolontariusza'),
                      min: minimalVolunteerAge.toDouble(),
                      max: maximalVolunteerAge.toDouble(),
                      divisions: maximalVolunteerAge - minimalVolunteerAge + 1,
                      initialValue: RangeValues(minimalVolunteerAge.toDouble(),
                          maximalVolunteerAge.toDouble()),
                      numberFormat: NumberFormat('### lat'),
                    ),
                    const SizedBox(height: 20),
                    FormBuilderRangeSlider(
                      name: 'volunteer_count_range',
                      decoration: const InputDecoration(
                          labelText: 'Ilość wolontariuszy'),
                      min: minimalVolunteerCount.toDouble(),
                      max: maximalVolunteerCount.toDouble(),
                      divisions:
                          maximalVolunteerCount - minimalVolunteerCount + 1,
                      initialValue: RangeValues(
                          minimalVolunteerCount.toDouble(),
                          maximalVolunteerCount.toDouble()),
                      numberFormat: NumberFormat('###'),
                    ),
                    const SizedBox(height: 20),
                  ])),
        ));
  }
}
