import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomagacze/components/error_with_action.dart';
import 'package:pomagacze/components/user_avatar.dart';
import 'package:pomagacze/models/user_profile.dart';
import 'package:pomagacze/pages/profile.dart';
import 'package:pomagacze/state/friendships.dart';
import 'package:pomagacze/utils/xp.dart';

class FriendsPage extends ConsumerStatefulWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  FriendsPageState createState() => FriendsPageState();
}

class FriendsPageState extends ConsumerState<FriendsPage> {
  @override
  Widget build(BuildContext context) {
    final friends = ref.watch(friendsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Znajomi'), actions: [
        IconButton(onPressed: () {
          Navigator.of(context).pushNamed('/search-users');
        }, icon: const Icon(Icons.person_add))
      ]),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(friendsIdsProvider.future),
        child: friends.when(
            data: (data) => _buildSuccess(data),
            error: (err, stack) => ErrorWithAction(
                action: () {
                  ref.invalidate(friendsProvider);
                },
                actionText: 'Odśwież'),
            loading: () => const Center(child: CircularProgressIndicator())),
      ),
    );
  }

  Widget _buildSuccess(List<UserProfile> friends) {
    if (friends.isEmpty) {
      return ErrorWithAction(
          action: () {},
          errorText: 'Nie masz żadnych znajomych... :(',
          actionText: 'Szukaj znajomych');
    }

    return ListView.builder(
        itemBuilder: (context, i) {
          var userProfile = friends[i];
          return ListTile(
            title: Text(userProfile.name ?? ''),
            leading: UserAvatar(userProfile),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  formatXP(userProfile.xp),
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                const SizedBox(width: 3),
                Icon(Icons.local_fire_department,
                    color: Theme.of(context).colorScheme.error)
              ],
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProfilePage(userProfile: userProfile)));
            },
          );
        },
        itemCount: friends.length);
  }
}
