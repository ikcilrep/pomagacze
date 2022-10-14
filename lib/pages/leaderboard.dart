import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:pomagacze/components/user_avatar.dart';
import 'package:pomagacze/models/user_profile.dart';
import 'package:pomagacze/pages/profile.dart';
import 'package:pomagacze/state/friendships.dart';
import 'package:pomagacze/state/user.dart';
import 'package:pomagacze/utils/constants.dart';
import 'package:pomagacze/utils/xp.dart';

enum _LeaderboardType {
  world(0),
  friends(1);

  final int value;

  const _LeaderboardType(this.value);

  static _LeaderboardType fromInteger(int value) =>
      _LeaderboardType.values.firstWhere((x) => x.value == value);
}

class LeaderboardPage extends ConsumerStatefulWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

  @override
  LeaderboardPageState createState() => LeaderboardPageState();
}

class LeaderboardPageState extends ConsumerState<LeaderboardPage> {
  _LeaderboardType _currentSelection = _LeaderboardType.world;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            ref.refresh(friendsIdsProvider.future),
            ref.refresh(userProfilesProvider.future),
            ref.refresh(friendsAndUserProfilesProvider.future),
          ].toList());
        },
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          _buildLeaderboardTypeChooser(),
          const SizedBox(height: 10),
          Expanded(child: _buildLeaderboard()),
        ]),
      ),
    );
  }

  Widget _buildLeaderboard() {
    final userProfiles = ref.watch(userProfilesProvider);
    final friendsAndUserProfiles = ref.watch(friendsAndUserProfilesProvider);

    final entries = _currentSelection == _LeaderboardType.world
        ? userProfiles
        : friendsAndUserProfiles;

    return entries.when(
        data: (entries) => ListView.builder(
            padding: const EdgeInsets.only(top: 10),
            itemCount: entries.length,
            itemBuilder: (_, index) {
              return _buildUserTile(index, entries[index]);
            }),
        error: (err, stack) => Center(child: Text('Coś poszło nie tak: $err')),
        loading: () => const Center(child: CircularProgressIndicator()));
  }

  MaterialSegmentedControl<int> _buildLeaderboardTypeChooser() {
    return MaterialSegmentedControl(
      children: {
        _LeaderboardType.world.value: const Text('Świat'),
        _LeaderboardType.friends.value: const Text('Znajomi'),
      },
      selectionIndex: _currentSelection.value,
      borderColor: Theme.of(context).colorScheme.primary,
      selectedColor: Theme.of(context).colorScheme.primary,
      unselectedColor: Theme.of(context).colorScheme.surface,
      borderRadius: 32.0,
      verticalOffset: 10,
      horizontalPadding: const EdgeInsets.symmetric(horizontal: 20),
      onSegmentChosen: (index) {
        setState(() {
          _currentSelection = _LeaderboardType.fromInteger(index);
        });
      },
    );
  }

  Widget _buildUserTile(int position, UserProfile userProfile) {
    final isMe = userProfile.id == supabase.auth.currentUser?.id;
    return Material(
      color:
          isMe ? Theme.of(context).colorScheme.primary.withOpacity(0.1) : null,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProfilePage(userProfile: userProfile)));
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text((position + 1).toString(),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.8))),
              const SizedBox(width: 15),
              UserAvatar(userProfile, size: 45),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text((userProfile.name ?? '') + (isMe ? ' (Ty)' : ''),
                        style: Theme.of(context).textTheme.subtitle1),
                    Text('Poziom ${levelFromXP(userProfile.xp)}',
                        style: Theme.of(context).textTheme.bodySmall)
                  ],
                ),
              ),
              Text(formatXP(userProfile.xp),
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(width: 2),
              Icon(Icons.local_fire_department,
                  color: Theme.of(context).colorScheme.error, size: 17),
            ],
          ),
        ),
      ),
    );
  }
}
