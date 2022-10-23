import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pomagacze/models/user_profile.dart';

String getInitials(String name) {
  if (name.isEmpty) return '';
  return name[0].toUpperCase();
}

class UserAvatar extends StatelessWidget {
  final UserProfile userProfile;
  final double? size;

  const UserAvatar(this.userProfile, {Key? key, this.size = 50})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: size,
        height: size,
        color: Theme.of(context).colorScheme.error,
        child: userProfile.avatarURL != null
            ? CachedNetworkImage(
                imageUrl: userProfile.avatarURL ?? '',
                placeholder: (context, imageUrl) =>
                    const Center(child: CircularProgressIndicator()),
              )
            : Center(
                child: Text(getInitials(userProfile.name ?? ''),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onError))),
      ),
    );
  }
}
