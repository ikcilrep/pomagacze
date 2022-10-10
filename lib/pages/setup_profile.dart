import 'package:flutter/material.dart';
import 'package:pomagacze/components/edit_profile.dart';
import 'package:pomagacze/models/user_profile.dart';
import 'package:pomagacze/utils/constants.dart';

class SetupProfilePage extends StatelessWidget {
  const SetupProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tworzenie profilu')),
      body: EditProfile(
        initialData: UserProfile.fromData({
          'name': supabase.auth.currentUser?.userMetadata['name'],
        }),
        onSubmit: () {
          Navigator.of(context).pushReplacementNamed('/home');
        },
        showCancelButton: false,
      ),
    );
  }
}
