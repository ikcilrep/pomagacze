import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:gender_picker/gender_picker.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:pomagacze/components/auth_required_state.dart';
import 'package:pomagacze/models/user_profile.dart';
import 'package:pomagacze/utils/constants.dart';
import 'package:pomagacze/utils/misc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pomagacze/utils/user_profile_updates.dart';
import 'package:pomagacze/utils/snackbar.dart';
import 'package:pomagacze/utils/gender_serializing.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends AuthRequiredState<ProfilePage> {
  final _usernameController = TextEditingController();
  var _loading = true;
  var _initialized = false;
  late UserProfile userProfile;

  Future<void> _fetchProfile(String userId) async {
    setState(() {
      _loading = true;
    });

    userProfile =
        await UserProfileUpdates.fetchFromDatabase(userId, onError: (message) {
      if (mounted) {
        context.showErrorSnackBar(message: message);
      }
    });

    _usernameController.text = userProfile.name ?? '';

    setState(() {
      _loading = false;
      _initialized = true;
    });
  }

  Future<void> _saveChanges() async {
    setState(() {
      _loading = true;
    });

    userProfile.name = _usernameController.text;
    final error = await userProfile.pushToDatabase();
    _showErrorOrSuccessMessage(error);

    setState(() {
      _loading = false;
    });
  }

  void _showErrorOrSuccessMessage(PostgrestError? error) {
    if (mounted) {
      if (error != null) {
        context.showErrorSnackBar(message: error.message);
      } else {
        context.showSnackBar(message: 'Udało się pomyślnie zapisać zmiany!');
      }
    }
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
    if (!_initialized) return Center(child: CircularProgressIndicator());

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
        const SizedBox(height: 18),
        ElevatedButton(
          onPressed: _saveChanges,
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary),
          child: _loading
              ? Transform.scale(
                  scale: 0.7,
                  child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.onPrimary))
              : Text('Zapisz'),
        ),
        const SizedBox(height: 12),
        OutlinedButton(onPressed: _signOut, child: const Text('Wyloguj się')),
      ],
    );
  }
}
