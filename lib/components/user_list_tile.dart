import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomagacze/components/user_avatar.dart';
import 'package:pomagacze/models/user_profile.dart';
import 'package:pomagacze/pages/profile.dart';
import 'package:pomagacze/state/users.dart';
import 'package:pomagacze/utils/xp.dart';

class UserListTile extends ConsumerStatefulWidget {
  final UserProfile userProfile;

  const UserListTile({Key? key, required this.userProfile}) : super(key: key);

  @override
  ConsumerState<UserListTile> createState() => _UserListTileState();
}

class _UserListTileState extends ConsumerState<UserListTile> {
  @override
  Widget build(BuildContext context) {
    var userData = ref.watch(userProfileProvider(widget.userProfile.id));
    var user = userData.valueOrNull ?? widget.userProfile;
    
    return Material(
      type: MaterialType.transparency,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        title: Text(user.name ?? ''),
        leading: UserAvatar(user),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              formatXP(user.xp),
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(width: 3),
            Icon(Icons.favorite, color: Theme.of(context).colorScheme.error)
          ],
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProfilePage(userProfile: user)));
        },
      ),
    );
  }
}
