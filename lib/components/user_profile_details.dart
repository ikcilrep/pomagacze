import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomagacze/models/user_profile.dart';
import 'package:pomagacze/utils/gender_serializing.dart';
import 'package:pomagacze/utils/xp.dart';

import 'user_avatar.dart';

class UserProfileDetails extends ConsumerStatefulWidget {
  final UserProfile userProfile;
  final Widget? iconButton;
  final List<Widget> children;

  const UserProfileDetails(
      {Key? key,
      required this.userProfile,
      this.iconButton,
      this.children = const []})
      : super(key: key);

  @override
  ConsumerState<UserProfileDetails> createState() => _UserProfileDetailsState();
}

class _UserProfileDetailsState extends ConsumerState<UserProfileDetails> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      children: [
        Row(
          children: [
            UserAvatar(widget.userProfile),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.userProfile.name ?? '',
                    style: Theme.of(context).textTheme.headline6),
                Text('${widget.userProfile.gender?.display()} • ${widget.userProfile.age} l.')
              ],
            ),
            Expanded(child: Container()),
            if (widget.iconButton != null) widget.iconButton!
          ],
        ),
        const SizedBox(height: 50),
        _buildSummary(context),
        const SizedBox(height: 40),
        ...widget.children,
      ],
    );
  }

  Widget _buildSummary(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SizedBox(
                height: 50,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: getProgressToNextLevel(widget.userProfile.xp),
                      color: Theme.of(context).colorScheme.error,
                      backgroundColor:
                          Theme.of(context).colorScheme.error.withAlpha(35),
                    ),
                    Text(levelFromXP(widget.userProfile.xp).toString(),
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
                    Text(formatXP(widget.userProfile.xp),
                        style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text('PUNKTY', style: Theme.of(context).textTheme.overline)
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
                    Text(formatXP(widget.userProfile.xpThisMonth),
                        style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text('TEN MIESIĄC', style: Theme.of(context).textTheme.overline)
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
                    Text(formatXP(widget.userProfile.xpThisWeek),
                        style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text('TEN TYDZIEŃ', style: Theme.of(context).textTheme.overline)
            ],
          ),
        ],
      ),
    );
  }
}
