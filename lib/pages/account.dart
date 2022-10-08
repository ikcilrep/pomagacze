import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:gender_picker/gender_picker.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:pomagacze/components/auth_required_state.dart';
import 'package:pomagacze/models/user_profile.dart';
import 'package:pomagacze/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pomagacze/utils/gender_serializing.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends AuthRequiredState<AccountPage> {
  final _usernameController = TextEditingController();
  var _loading = true;
  final UserProfile userProfile = UserProfile();
  /// Called once a user id is received within `onAuthenticated()`
  Future<void> _getProfile(String userId) async {
    setState(() {
      _loading = true;
    });
    final response = await supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .single()
        .execute();
    final error = response.error;
    if (error != null && response.status != 406 && mounted) {
      context.showErrorSnackBar(message: error.message);
    }
    final data = response.data;
    if (data != null) {
      _usernameController.text = (data['name'] ?? '') as String;
      userProfile.gender = deserializeGender(data['gender']);
      userProfile.birthDate = DateTime.tryParse(data['birth_date']);
    }
    setState(() {
      _loading = false;
    });
  }

  /// Called when user taps `Update` button
  Future<void> _updateProfile() async {
    setState(() {
      _loading = true;
    });
    final userName = _usernameController.text;
    final user = supabase.auth.currentUser;
    final updates = {
      'id': user!.id,
      'name': userName,
      'birth_date': userProfile.birthDate?.toIso8601String().toString(),
      'gender': userProfile.gender?.serialize().toString(),
      'updated_at': DateTime.now().toIso8601String(),
    };
    final response = await supabase.from('profiles').upsert(updates).execute();

    if (mounted) {
      final error = response.error;
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
      _getProfile(user.id);
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
                    onPressed: _updateProfile,
                    child: Text(_loading ? 'Zapisywanie...' : 'Zapisz')),
                const SizedBox(height: 18),
                ElevatedButton(
                    onPressed: _signOut, child: const Text('Wyloguj się')),
              ],
            ),
    );
  }
}
