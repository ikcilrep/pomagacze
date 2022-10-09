import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:pomagacze/db/db.dart';
import 'package:pomagacze/models/help_request.dart';
import 'package:pomagacze/utils/snackbar.dart';

class RequestForm extends StatefulWidget {
  HelpRequest? initialData;

  RequestForm({Key? key, this.initialData}) : super(key: key);

  @override
  State<RequestForm> createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  bool _loading = false;
  bool _allDay = false;

  @override
  void initState() {
    super.initState();
  }

  void _submit() async {
    if (!_formKey.currentState!.saveAndValidate()) return;

    setState(() {
      _loading = true;
    });

    var values = {..._formKey.currentState!.value, 'date_all_day': _allDay};

    await RequestsDB.upsert(HelpRequest.fromData(values)).catchError((err) {
      context.showErrorSnackBar(message: err.toString());
    });

    setState(() {
      _loading = false;
    });
    Navigator.of(context).pop();
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
                    child: CircularProgressIndicator(color: Colors.white))
                : const Icon(Icons.send)),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FormBuilder(
                key: _formKey,
                initialValue: widget.initialData?.toData() ?? {},
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
                      SwitchListTile(
                        title: const Text('Cały dzień'),
                        value: _allDay,
                        onChanged: (v) {
                          setState(() {
                            _allDay = v;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      FormBuilderField(
                        name: 'date_start',
                        initialValue: DateTime.now(),
                        builder: (field) {
                          return DateTimePicker(
                            type: _allDay
                                ? DateTimePickerType.date
                                : DateTimePickerType.dateTimeSeparate,
                            key: Key(field.value.toString()),
                            dateMask: 'EE, dd MMM yyyy',
                            initialValue: field.value.toString(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2500),
                            onChanged: (dateTimeString) {
                              var date = DateTime.tryParse(dateTimeString);
                              if (date == null) return;

                              field.didChange(date);

                              print(_formKey
                                  .currentState!.fields['date_end']?.value);

                              if (date.isAfter(_formKey.currentState!
                                  .fields['date_end']?.value as DateTime)) {
                                print('lol');
                                _formKey.currentState!.fields['date_end']
                                    ?.didChange(date);
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
                        initialValue: DateTime.now().add(Duration(hours: 1)),
                        builder: (field) {
                          return DateTimePicker(
                            type: _allDay
                                ? DateTimePickerType.date
                                : DateTimePickerType.dateTimeSeparate,
                            dateMask: 'EE, dd MMM yyyy',
                            initialValue: field.value.toString(),
                            key: Key(field.value.toString()),
                            firstDate: _formKey.currentState
                                    ?.fields['date_start']?.value ??
                                DateTime.now(),
                            lastDate: DateTime(2500),
                            onChanged: (dateTimeString) {
                              var date = DateTime.tryParse(dateTimeString);
                              if (date == null) return;

                              field.didChange(date);
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
