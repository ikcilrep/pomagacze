import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:gender_picker/gender_picker.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:pomagacze/components/auth_required_state.dart';
import 'package:pomagacze/models/user_profile.dart';
import 'package:pomagacze/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pomagacze/utils/user_profile_updates.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends AuthRequiredState<ProfilePage> {
  final _usernameController = TextEditingController();
  var _loading = true;
  late UserProfile userProfile;

  Future<void> _fetchProfile(String userId) async {
    setState(() {
      _loading = true;
    });

    userProfile = await UserProfileUpdates.fetchFromDatabase(userId, onError: (message) {
      if (mounted) {
        context.showErrorSnackBar(message: message);
      }
    });

    _usernameController.text = userProfile.name ?? '';

    setState(() {
      _loading = false;
    });
  }

  Future<void> _saveChanges() async {
    setState(() {
      _loading = true;
    });

    userProfile.name = _usernameController.text;
    final error = await userProfile.pushToDatabase();
    if (mounted) {
      if (error != null) {
        context.showErrorSnackBar(message: error.message);
      } else {
        context.showSnackBar(message: 'Udało się pomyślnie zapisać zmiany!');
      }
    }

    setState(() {
      _loading = false;
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
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
              children: [
                GenderPickerWithImage(
                  showOtherGender: true,
                  verticalAlignedText: false,
                  selectedGender: userProfile.gender,
                  selectedGenderTextStyle: const TextStyle(
                      color: Color(0xFF8b32a8), fontWeight: FontWeight.bold),
                  unSelectedGenderTextStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.normal),
                  onChanged: (Gender? gender) {
                    userProfile.gender = gender;
                  },
                  equallyAligned: true,
                  animationDuration: const Duration(milliseconds: 300),
                  isCircular: true,
                  // default : true,
                  opacityOfGradient: 0.4,
                  padding: const EdgeInsets.all(3),
                  size: 50, //default : 40
                ),
                DateTimePicker(
                  type: DateTimePickerType.date,
                  dateMask: 'd MMM, yyyy',
                  initialValue: userProfile.birthDate?.toString(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  icon: const Icon(Icons.event),
                  dateLabelText: 'Data urodzenia',
                  onChanged: (dateTimeString) {
                    userProfile.birthDate = DateTime.tryParse(dateTimeString);
                  },
                ),
                TextFormField(
                  controller: _usernameController,
                  decoration:
                      const InputDecoration(labelText: 'Nazwa użytkownika'),
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                    onPressed: _saveChanges,
                    child: Text(_loading ? 'Zapisywanie...' : 'Zapisz')),
                const SizedBox(height: 18),
                ElevatedButton(
                    onPressed: _signOut, child: const Text('Wyloguj się')),
              ],
            ),
    );
  }
}
