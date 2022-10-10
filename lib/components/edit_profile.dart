import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:intl/intl.dart';
import 'package:open_location_picker/open_location_picker.dart';
import 'package:pomagacze/components/buttons.dart';
import 'package:pomagacze/db/users.dart';
import 'package:pomagacze/models/user_profile.dart';
import 'package:pomagacze/state/user.dart';
import 'package:pomagacze/utils/string_extensions.dart';
import 'package:pomagacze/utils/snackbar.dart';
import 'package:pomagacze/utils/gender_serializing.dart';

class EditProfile extends ConsumerStatefulWidget {
  final String? title;
  final bool showCancelButton;
  final VoidCallback? onSubmit;
  final UserProfile? initialData;

  const EditProfile(
      {Key? key,
      this.title,
      this.showCancelButton = true,
      this.onSubmit,
      this.initialData})
      : super(key: key);

  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends ConsumerState<EditProfile> {
  var _isLoading = false;
  late UserProfile userProfile;

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    userProfile =
        ref.read(userProfileProvider).valueOrNull ?? UserProfile.empty();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.saveAndValidate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      var data = UserProfile.fromData({
        ...(_formKey.currentState?.value ?? {}),
        'birth_date': _formKey.currentState?.value['birth_date'].toString()
      });
      await UsersDB.upsert(data);
      ref.refresh(userProfileProvider);
      if (mounted) {
        context.showSnackBar(message: 'Pomyślnie zapisano zmiany!');
      }
    } catch (err) {
      if (mounted) {
        context.showErrorSnackBar(message: err.toString());
        rethrow;
      }
    }

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      widget.onSubmit?.call();
    }
  }

  Map<String, dynamic> toFormData(UserProfile userProfile) {
    return {...userProfile.toJson(), 'birth_date': userProfile.birthDate};
  }

  @override
  Widget build(BuildContext context) {
    var userProfileAsync = ref.watch(userProfileProvider);

    if (userProfileAsync.hasError) return const Text('Coś poszło nie tak');
    if (userProfileAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return FormBuilder(
      key: _formKey,
      initialValue: toFormData(widget.initialData ??
          userProfileAsync.valueOrNull ??
          UserProfile.empty()),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.title != null)
              Text('Edytuj profil',
                  style: Theme.of(context).textTheme.headline6),
            if (widget.title != null) const SizedBox(height: 20),
            FormBuilderTextField(
              name: 'name',
              decoration: const InputDecoration(labelText: 'Nazwa użytkownika'),
              validator: FormBuilderValidators.required(
                  errorText: 'Nazwa użytkownika nie może być pusta!'),
            ),
            const SizedBox(height: 12),
            FormBuilderDropdown(
              name: 'gender',
              items: Gender.values.map((value) {
                return DropdownMenuItem<String>(
                  value: value.serialize(),
                  child: Text(value.display().capitalizeFirst()),
                );
              }).toList(),
              decoration: const InputDecoration(labelText: 'Płeć'),
              validator: FormBuilderValidators.required(),
            ),
            const SizedBox(height: 12),
            FormBuilderDateTimePicker(
                name: 'birth_date',
                inputType: InputType.date,
                decoration: const InputDecoration(labelText: 'Data urodzenia'),
                format: DateFormat('d MMM yyyy')),
            const SizedBox(height: 12),
            OpenMapPicker(
              initialValue: userProfile.location,
              decoration: const InputDecoration(
                labelText: "Miejsce zamieszkania",
                prefixIconConstraints: BoxConstraints(maxWidth: 0),
                prefixIcon: Icon(null),
                suffixIcon: Icon(Icons.location_pin),
              ),
              removeIcon: Icon(Icons.clear,
                  color: Theme.of(context).colorScheme.onSurface),
              onChanged: (FormattedLocation? newValue) {
                userProfile.location = newValue;
              },
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                if (widget.showCancelButton)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Anuluj'),
                    ),
                  ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveChanges,
                    style: primaryButtonStyle(context),
                    child: _isLoading
                        ? Transform.scale(
                            scale: 0.7,
                            child: CircularProgressIndicator(
                                color: Theme.of(context).colorScheme.onPrimary))
                        : const Text('Zapisz'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
