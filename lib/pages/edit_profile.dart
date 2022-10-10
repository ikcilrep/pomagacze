import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:open_location_picker/open_location_picker.dart';
import 'package:pomagacze/components/buttons.dart';
import 'package:pomagacze/db/users.dart';
import 'package:pomagacze/models/user_profile.dart';
import 'package:pomagacze/state/user.dart';
import 'package:pomagacze/utils/string_extensions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pomagacze/utils/snackbar.dart';
import 'package:pomagacze/utils/gender_serializing.dart';

class EditProfilePage extends ConsumerStatefulWidget {

  const EditProfilePage({Key? key}) : super(key: key);

  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _usernameController = TextEditingController();
  var _isLoading = false;
  late UserProfile userProfile;

  @override
  void initState() {
    super.initState();
    userProfile = ref.read(userProfileProvider).value!;
    _usernameController.text = userProfile.name ?? '';
  }

  Future<void> _saveChanges() async {
    setState(() {
      _isLoading = true;
    });

    userProfile.name = _usernameController.text;

    try {
      await UsersDB.update(userProfile);
      ref.refresh(userProfileProvider);
      if (mounted) {
        context.showSnackBar(message: 'Udało się pomyślnie zapisać zmiany!');
      }
    } catch (err) {
      if (mounted) {
        context.showErrorSnackBar(message: (err as PostgrestError).message);
      }
    }

    setState(() {
      _isLoading = false;
    });

    if(mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var userProfileAsync = ref.watch(userProfileProvider);

    if(userProfileAsync.hasError) return const Text('Coś poszło nie tak');
    if(userProfileAsync.isLoading) return const Center(child: CircularProgressIndicator());

    var userProfile = userProfileAsync.value!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Edytuj profil', style: Theme.of(context).textTheme.headline6),
          const SizedBox(height: 20),
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(labelText: 'Nazwa użytkownika'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<Gender>(
            items: Gender.values.map((value) {
              return DropdownMenuItem<Gender>(
                value: value,
                child: Text(value.display().capitalizeFirst()),
              );
            }).toList(),
            decoration: const InputDecoration(labelText: 'Płeć'),
            value: userProfile.gender,
            onChanged: (newGender) { userProfile.gender = newGender;},
          ),
          const SizedBox(height: 12),
          DateTimePicker(
            type: DateTimePickerType.date,
            dateMask: 'd MMM, yyyy',
            initialValue: userProfile.birthDate?.toString(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
            // icon: const Icon(Icons.event),
            dateLabelText: 'Data urodzenia',
            onChanged: (dateTimeString) {
              userProfile.birthDate = DateTime.tryParse(dateTimeString);
            },
            decoration: const InputDecoration(labelText: 'Data urodzenia'),
          ),
          const SizedBox(height: 12),
          OpenMapPicker(
            initialValue: userProfile.location,
            decoration: const InputDecoration(
              labelText: "Miejsce zamieszkania"
            ),
            removeIcon: Icon(Icons.clear, color: Theme.of(context).colorScheme.onSurface),
            onChanged: (FormattedLocation? newValue) {
              userProfile.location = newValue;
            },
          ),
          const SizedBox(height: 18),
          Row(
            children: [
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
    );
  }
}
