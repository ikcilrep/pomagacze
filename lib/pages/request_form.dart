import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:open_location_picker/open_location_picker.dart';
import 'package:pomagacze/db/db.dart';
import 'package:pomagacze/models/help_request.dart';
import 'package:pomagacze/utils/constants.dart';
import 'package:pomagacze/utils/snackbar.dart';

class RequestForm extends StatefulWidget {
  final HelpRequest? initialData;

  const RequestForm({Key? key, this.initialData}) : super(key: key);

  @override
  State<RequestForm> createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  bool _loading = false;

  FormattedLocation? _location;

  @override
  void initState() {
    super.initState();
  }

  void _submit() async {
    if (!_formKey.currentState!.saveAndValidate()) return;

    setState(() {
      _loading = true;
    });

    var values = {
      ..._formKey.currentState!.value,
      'author_id': supabase.auth.currentUser?.id,
      'place_name': _location?.displayName,
      'latitude': _location?.lat,
      'longitude': _location?.lon,
    };


    await RequestsDB.update(HelpRequest.fromData(values)).catchError((err) {
      context.showErrorSnackBar(message: err.toString());
    });

    setState(() {
      _loading = false;
    });
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Nowa prośba o pomoc')),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: _submit,
            label: const Text('Opublikuj'),
            icon: _loading
                ? Transform.scale(
                    scale: 0.6,
                    child: const CircularProgressIndicator(color: Colors.white))
                : const Icon(Icons.send)),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FormBuilder(
                key: _formKey,
                initialValue: widget.initialData?.toJson() ?? {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        minLines: 3,
                        // any number you need (It works as the rows for the textarea)
                        keyboardType: TextInputType.multiline,
                        maxLines: 8,
                        decoration: const InputDecoration(labelText: 'Opis'),
                        validator: FormBuilderValidators.required(
                            errorText: 'Opis nie może być pusty'),
                      ),
                      const SizedBox(height: 25),
                      OpenMapPicker(
                        decoration: const InputDecoration(
                          hintText: "Miejsce zbiórki",
                        ),
                        onChanged: (FormattedLocation? newValue) {
                          _location = newValue;
                        },
                      ),
                      const SizedBox(height: 10),
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
                        initialValue:
                            DateTime.now().add(const Duration(hours: 1)).toString(),
                        builder: (field) {
                          return DateTimePicker(
                            type: DateTimePickerType.dateTimeSeparate,
                            dateMask: 'EE, dd MMM yyyy',
                            initialValue: field.value.toString(),
                            key: Key(field.value.toString()),
                            firstDate: DateTime.tryParse(_formKey.currentState
                                    ?.fields['date_start']?.value) ??
                                DateTime.now(),
                            lastDate: DateTime(2500),
                            onChanged: (dateTimeString) {
                              field.didChange(dateTimeString);
                            },
                            dateLabelText: 'Data zakończenia',
                            timeLabelText: 'Godzina',
                          );
                        },
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
