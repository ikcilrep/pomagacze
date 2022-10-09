import 'package:age_calculator/age_calculator.dart';
import 'package:avatars/avatars.dart';
import 'package:flutter/material.dart';
import 'package:pomagacze/components/auth_required_state.dart';
import 'package:pomagacze/db/db.dart';
import 'package:pomagacze/models/user_profile.dart';
import 'package:pomagacze/pages/edit_profile.dart';
import 'package:pomagacze/utils/constants.dart';
import 'package:pomagacze/utils/gender_serializing.dart';
import 'package:pomagacze/utils/snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends AuthRequiredState<ProfilePage> {
  var _isInitialized = false;
  late UserProfile userProfile;

  Future<void> _fetchProfile(String userId) async {
    userProfile = await UsersDB.getById(userId).catchError((err) {
      if (mounted) {
        context.showErrorSnackBar(message: (err as PostgrestError).message);
      }
    });

    setState(() {
      _isInitialized = true;
    });
  }

  @override
  void onAuthenticated(Session session) {
    final user = session.user;
    if (user != null) {
      _fetchProfile(user.id);
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
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Avatar(
                  shape: AvatarShape.circle(25),
                  name: userProfile.name,
                  placeholderColors: [
                    Theme.of(context).colorScheme.primary,
                  ]),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userProfile.name!,
                      style: Theme.of(context).textTheme.headline6),
                  Text('${userProfile.gender?.display()} • ${AgeCalculator.age(userProfile.birthDate!).years} l.')
                ],
              ),
              Expanded(child: Container()),
              IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return Wrap(children: [
                            EditProfilePage(userProfile: userProfile)
                          ]);
                        });
                  },
                  icon: const Icon(Icons.edit))
            ],
          ),
          const SizedBox(height: 20),
          OutlinedButton(onPressed: _signOut, child: const Text('Wyloguj się')),
        ],
      ),
    );
  }
}
