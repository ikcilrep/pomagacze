import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:pomagacze/models/user_profile.dart';
import 'package:pomagacze/state/user.dart';

class CommunityPage extends ConsumerStatefulWidget {
  const CommunityPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => CommunityPageState();
}

enum _LeaderboardType {
  world(0), friends(1);

  final int value;
  const _LeaderboardType(this.value);
  
  static _LeaderboardType fromInteger(int value) =>
      _LeaderboardType.values.firstWhere((x) => x.value == value);
}

class CommunityPageState extends ConsumerState<CommunityPage> {
  _LeaderboardType _currentSelection = _LeaderboardType.world;

  Widget _buildUserTile(int position, UserProfile userProfile) => ListTile(
    title: Text(
      "$position. ${userProfile.name!}",
    ),
    subtitle: Text("${userProfile.xp.toString()} punktów"),
  );

  @override
  Widget build(BuildContext context) {
    final userProfiles = ref.watch(userProfilesProvider);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            title: const Text('Ranking'),
            bottom: TabBar(
              tabs: const [
                Tab(
                  text: 'Ranking',
                ),
                Tab(
                  text: 'Aktywność',
                ),
              ],
              labelColor: Theme.of(context).colorScheme.onSurface,
              indicatorColor: Theme.of(context).colorScheme.primary,
            )),
        body: TabBarView(children: [
          userProfiles.hasValue
              ? _buildUserLeaderboard(userProfiles.value!)
              : Container(),
          Container()
        ]),
      ),
    );
  }

  ListView _buildUserLeaderboard(List<UserProfile> userProfiles) {
    userProfiles.sort((a, b) => b.xp.compareTo(a.xp));
    return ListView.builder(
      padding: const EdgeInsets.only(top: 10),
        itemCount: userProfiles.length + 1,
        itemBuilder: (_, index) {
          if (index == 0) {
            return _buildLeaderboardTypeChooser();
          }

          return _buildUserTile(index, userProfiles[index - 1]);
        });
  }

  MaterialSegmentedControl<int> _buildLeaderboardTypeChooser() {
    return MaterialSegmentedControl(
            children: {
              _LeaderboardType.world.value: const Text('Świat'),
              _LeaderboardType.friends.value: const Text('Znajomi'),
            },
            selectionIndex: _currentSelection.value,
            borderColor: Colors.teal,
            selectedColor: Colors.teal,
            unselectedColor: Colors.white,
            borderRadius: 32.0,
      onSegmentChosen: (index) {
        setState(() {
          _currentSelection = _LeaderboardType.fromInteger(index);
        });
      },
          );
  }
}
