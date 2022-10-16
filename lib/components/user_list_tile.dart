import 'package:flutter/material.dart';
import 'package:pomagacze/components/user_avatar.dart';
import 'package:pomagacze/models/user_profile.dart';
import 'package:pomagacze/pages/profile.dart';
import 'package:pomagacze/utils/xp.dart';

class UserListTile extends StatelessWidget {
  final UserProfile userProfile;

  const UserListTile({Key? key, required this.userProfile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
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
            Icon(Icons.favorite,
                color: Theme.of(context).colorScheme.error)
          ],
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  ProfilePage(userProfile: userProfile)));
        },
      ),
    );
  }
}
