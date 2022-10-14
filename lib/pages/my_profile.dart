import 'package:flutter/material.dart';
import 'package:pomagacze/components/profile_action.dart';
import 'package:pomagacze/components/user_profile_details.dart';
import 'package:pomagacze/models/user_profile.dart';
import 'package:pomagacze/components/edit_profile.dart';
import 'package:pomagacze/state/user.dart';
import 'package:pomagacze/utils/constants.dart';
import 'package:pomagacze/utils/snackbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    var currentUser = ref.watch(userProfileProvider);
    return currentUser.when(
        data: (data) => buildSuccess(data),
        error: (err, stack) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Coś poszło nie tak...'),
                const SizedBox(height: 10),
                ElevatedButton(
                    onPressed: _signOut, child: const Text('Wyloguj się'))
              ],
            ),
        loading: () => const Center(child: CircularProgressIndicator()));
  }

  Widget buildSuccess(UserProfile userProfile) {
    return RefreshIndicator(
        onRefresh: () => ref.refresh(userProfileProvider.future),
        child: UserProfileDetails(
          userProfile: userProfile,
          iconButton: IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return Wrap(children: [
                        Padding(
                          padding: MediaQuery.of(context).viewInsets,
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
            Divider(color: Theme.of(context).dividerColor.withAlpha(80)),
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
            Divider(color: Theme.of(context).dividerColor.withAlpha(80)),
            const ListTile(
              title: Text('Opcje'),
              trailing: Icon(Icons.arrow_forward),
            ),
            const ListTile(
              title: Text('O aplikacji'),
              trailing: Icon(Icons.arrow_forward),
            ),
            ProfileAction(
              onTap: _signOut,
              title: const Text('Wyloguj się'),
              icon: const Icon(Icons.logout),
            ),
          ],
        ));
  }
}
