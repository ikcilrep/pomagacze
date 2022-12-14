import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pomagacze/components/general/error_with_action.dart';
import 'package:pomagacze/components/profile/edit_profile.dart';
import 'package:pomagacze/components/profile/profile_action.dart';
import 'package:pomagacze/components/profile/user_profile_details.dart';
import 'package:pomagacze/models/user_profile.dart';
import 'package:pomagacze/state/leaderboard.dart';
import 'package:pomagacze/state/users.dart';
import 'package:pomagacze/utils/constants.dart';
import 'package:pomagacze/utils/snackbar.dart';

class MyProfilePage extends ConsumerStatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends ConsumerState<MyProfilePage> {
  Future<void> _signOut() async {
    final response = await supabase.auth.signOut();
    final error = response.error;
    if (error != null && mounted) {
      context.showErrorSnackBar(message: error.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    var currentUser = ref.watch(currentUserProvider);
    return currentUser.when(
        data: (data) => buildSuccess(data),
        error: (err, stack) =>
            ErrorWithAction(
                action: _signOut, error: err, actionText: 'Wyloguj się'),
        loading: () => const Center(child: CircularProgressIndicator()));
  }

  Widget buildSuccess(UserProfile userProfile) {
    return RefreshIndicator(
        onRefresh: () {
          ref.invalidate(leaderboardProvider);
          return Future.wait([
            ref.refresh(currentUserProvider.future),
          ]);
        },
        child: UserProfileDetails(
          userProfile: userProfile,
          iconButton: IconButton(
              onPressed: () {
                showModalBottomSheet(
                    shape: bottomSheetShape,
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return Wrap(children: [
                        Padding(
                          padding: MediaQuery
                              .of(context)
                              .viewInsets,
                          child: EditProfile(
                            title: 'Edytuj profil',
                            onSubmit: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        )
                      ]);
                    });
              },
              icon: const Icon(Icons.edit)),
          children: [
            ProfileAction(
              onTap: () {
                Fluttertoast.showToast(msg: 'Funkcja dostępna wkrótce!');
              },
              title: const Text('Wymień punkty'),
              icon: const Icon(Icons.arrow_forward),
            ),
            Divider(color: Theme
                .of(context)
                .dividerColor
                .withAlpha(80)),
            ProfileAction(
              onTap: () {
                Navigator.of(context).pushNamed('/events-joined');
              },
              title: const Text('Wydarzenia, w których uczestniczę'),
              icon: const Icon(Icons.arrow_forward),
            ),
            ProfileAction(
              onTap: () {
                Navigator.of(context).pushNamed('/my-events');
              },
              title: const Text('Moje wydarzenia'),
              icon: const Icon(Icons.arrow_forward),
            ),
            Divider(color: Theme
                .of(context)
                .dividerColor
                .withAlpha(80)),
            ProfileAction(
                title: const Text('Wprowadzenie'),
                icon: const Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.of(context).pushNamed('/onboarding');
                }),
            ProfileAction(
                title: const Text('Jak pomagać?'),
                icon: const Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.of(context).pushNamed('/learn');
                }),
            ProfileAction(
                title: const Text('O aplikacji'),
                icon: const Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.of(context).pushNamed('/about');
                }),
            Divider(color: Theme
                .of(context)
                .dividerColor
                .withAlpha(80)),
            ProfileAction(
              onTap: _signOut,
              title: const Text('Wyloguj się'),
              icon: const Icon(Icons.logout),
            ),
          ],
        ));
  }
}
