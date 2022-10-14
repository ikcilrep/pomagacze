import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomagacze/components/profile_action.dart';
import 'package:pomagacze/components/user_profile_details.dart';
import 'package:pomagacze/models/user_profile.dart';

class ProfilePage extends ConsumerStatefulWidget {
  final UserProfile userProfile;

  const ProfilePage({Key? key, required this.userProfile}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil użytkownika')),
      body: UserProfileDetails(
        userProfile: widget.userProfile,
        children: [
          ProfileAction(
            title: const Text('Dodaj znajomego'),
            icon: const Icon(Icons.person_add),
            onTap: () {

            },
          )
        ],
      ),
    );
  }
}
