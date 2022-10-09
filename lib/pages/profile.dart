import 'package:age_calculator/age_calculator.dart';
import 'package:avatars/avatars.dart';
import 'package:flutter/material.dart';
import 'package:pomagacze/models/user_profile.dart';
import 'package:pomagacze/pages/edit_profile.dart';
import 'package:pomagacze/state/user.dart';
import 'package:pomagacze/utils/constants.dart';
import 'package:pomagacze/utils/gender_serializing.dart';
import 'package:pomagacze/utils/snackbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends ConsumerState<ProfilePage> {
  Future<void> _signOut() async {
    final response = await supabase.auth.signOut();
    final error = response.error;
    if (error != null && mounted) {
      context.showErrorSnackBar(message: error.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    var currentUser = ref.watch(userProfileProvider);
    return currentUser.when(
        data: (data) => buildSuccess(context, data),
        error: (err, stack) => const Center(child: Text('Błąd!')),
        loading: () => const Center(child: CircularProgressIndicator()));
  }

  Widget buildSuccess(BuildContext context, UserProfile userProfile) {
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
                  Text(
                      '${userProfile.gender?.display()} • ${AgeCalculator.age(userProfile.birthDate!).years} l.')
                ],
              ),
              Expanded(child: Container()),
              IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return Wrap(children: const [
                            EditProfilePage()
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
