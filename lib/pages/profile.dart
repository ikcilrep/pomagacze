import 'package:avatars/avatars.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pomagacze/models/user_profile.dart';
import 'package:pomagacze/components/edit_profile.dart';
import 'package:pomagacze/state/user.dart';
import 'package:pomagacze/utils/constants.dart';
import 'package:pomagacze/utils/gender_serializing.dart';
import 'package:pomagacze/utils/snackbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomagacze/utils/xp.dart';

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

  Widget buildSuccess(BuildContext context, UserProfile userProfile) {
    return RefreshIndicator(
      onRefresh: () => ref.refresh(userProfileProvider.future),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        children: [
          Row(
            children: [
              Avatar(
                  useCache: true,
                  shape: AvatarShape.circle(25),
                  name: userProfile.name,
                  sources: [
                    NetworkSource(
                        supabase.auth.currentUser?.userMetadata['avatar_url'])
                  ],
                  placeholderColors: [
                    Theme.of(context).colorScheme.primary,
                  ]),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userProfile.name ?? '',
                      style: Theme.of(context).textTheme.headline6),
                  Text(
                      '${userProfile.gender?.display()} • ${userProfile.age} l.')
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
                  icon: const Icon(Icons.edit))
            ],
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 50,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: 0.7,
                          color: Theme.of(context).colorScheme.error,
                          backgroundColor:
                              Theme.of(context).colorScheme.error.withAlpha(20),
                        ),
                        Text(levelFromXP(userProfile.xp).toString(),
                            style: Theme.of(context).textTheme.titleMedium)
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('POZIOM', style: Theme.of(context).textTheme.overline)
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        Icon(Icons.local_fire_department,
                            color: Theme.of(context).colorScheme.error),
                        const SizedBox(width: 5),
                        Text(NumberFormat.compact().format(userProfile.xp),
                            style: Theme.of(context).textTheme.titleLarge),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('PUNKTY POMOCY',
                      style: Theme.of(context).textTheme.overline)
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        Icon(Icons.local_fire_department,
                            color: Theme.of(context).colorScheme.error),
                        const SizedBox(width: 5),
                        Text('650',
                            style: Theme.of(context).textTheme.titleLarge),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('W TYM MIESIĄCU',
                      style: Theme.of(context).textTheme.overline)
                ],
              ),
            ],
          ),
          const SizedBox(height: 40),
          Divider(color: Theme.of(context).dividerColor.withAlpha(80)),
          const ListTile(
            title: Text('Wydarzenia w których uczestniczę'),
            trailing: Icon(Icons.arrow_forward),
          ),
          const ListTile(
            title: Text('Moje wydarzenia'),
            trailing: Icon(Icons.arrow_forward),
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
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Material(
              child: InkWell(
                onTap: _signOut,
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  title: const Text('Wyloguj się'),
                  trailing: const Icon(Icons.logout),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
