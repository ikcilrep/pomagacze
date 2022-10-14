import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pomagacze/models/user_profile.dart';
import 'package:pomagacze/utils/gender_serializing.dart';
import 'package:pomagacze/utils/xp.dart';

import 'user_avatar.dart';

class UserProfileDetails extends StatelessWidget {
  final UserProfile userProfile;
  final Widget? iconButton;
  final List<Widget> children;

  const UserProfileDetails({Key? key, required this.userProfile, this.iconButton, this.children = const []}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      children: [
        Row(
          children: [
            UserAvatar(userProfile),
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
            if(iconButton != null) iconButton!
          ],
        ),
        const SizedBox(height: 50),
        _buildSummary(context),
        const SizedBox(height: 40),
        ...children,
      ],
    );
  }

  Widget _buildSummary(BuildContext context) {
    return         Row(
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
                  Text(
                      NumberFormat.compact(locale: 'en')
                          .format(userProfile.xp),
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
    );
  }
}
