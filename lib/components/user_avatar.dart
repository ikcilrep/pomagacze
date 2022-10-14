import 'package:avatars/avatars.dart';
import 'package:flutter/material.dart';
import 'package:pomagacze/models/user_profile.dart';

class UserAvatar extends StatelessWidget {
  final UserProfile userProfile;
  final double? size;

  const UserAvatar(this.userProfile, {Key? key, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Avatar(
          useCache: true,
          shape: AvatarShape.circle(25),
          name: userProfile.name,
          sources: [
            if (userProfile.avatarURL != null)
              NetworkSource(userProfile.avatarURL!)
          ],
          placeholderColors: [
            Theme.of(context).colorScheme.primary,
          ]),
    );
  }
}
