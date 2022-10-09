import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:open_location_picker/open_location_picker.dart';
import 'package:pomagacze/components/auth_required_state.dart';
import 'package:pomagacze/components/buttons.dart';
import 'package:pomagacze/db/users.dart';
import 'package:pomagacze/models/user_profile.dart';
import 'package:pomagacze/utils/constants.dart';
import 'package:pomagacze/utils/string_extensions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pomagacze/utils/snackbar.dart';
import 'package:pomagacze/utils/gender_serializing.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends AuthRequiredState<ProfilePage> {
  final _usernameController = TextEditingController();
  var _isLoading = true;
  var _isInitialized = false;
  late UserProfile userProfile;

  Future<void> _fetchProfile(String userId) async {
    setState(() {
      _isLoading = true;
    });

    userProfile = await UsersDB.getById(userId).catchError((err) {
      if (mounted) {
        context.showErrorSnackBar(message: (err as PostgrestError).message);
      }
    });

    _usernameController.text = userProfile.name ?? '';

    setState(() {
      _isLoading = false;
      _isInitialized = true;
    });
  }

  Future<void> _saveChanges() async {
    setState(() {
      _isLoading = true;
    });

    userProfile.name = _usernameController.text;

    try {
      await UsersDB.update(userProfile);
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
  }

  Future<void> _signOut() async {
    final response = await supabase.auth.signOut();
    final error = response.error;
    if (error != null && mounted) {
      context.showErrorSnackBar(message: error.message);
    }
  }

  @override
  void onAuthenticated(Session session) {
    final user = session.user;
    if (user != null) {
      _fetchProfile(user.id);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      children: [
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
          onChanged: (_) {},
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
            hintText: "Miejsce zamieszkania",
          ),
          onChanged: (FormattedLocation? newValue) {
            userProfile.location = newValue;
          },
        ),
        const SizedBox(height: 18),
        ElevatedButton(
          onPressed: _saveChanges,
          style: primaryButtonStyle(context),
          child: _isLoading
              ? Transform.scale(
                  scale: 0.7,
                  child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.onPrimary))
              : const Text('Zapisz'),
        ),
        const SizedBox(height: 12),
        OutlinedButton(onPressed: _signOut, child: const Text('Wyloguj się')),
      ],
    );
  }
}
