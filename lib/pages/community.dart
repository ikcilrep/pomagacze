import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomagacze/models/user_profile.dart';
import 'package:pomagacze/state/user.dart';

class CommunityPage extends ConsumerWidget {
  const CommunityPage({Key? key}) : super(key: key);

  Widget _buildUserTile(int position, UserProfile userProfile) => ListTile(
        title: Text(
          "$position. ${userProfile.name!}",
        ),
        subtitle: Text("${userProfile.xp.toString()} punktów"),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfiles = ref.watch(userProfilesProvider);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            title: const Text('Ranking'),
            bottom: TabBar(
              tabs: const [
                Tab(
                  text: 'Świat',
                ),
                Tab(
                  text: 'Znajomi',
                )
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
        itemCount: userProfiles.length,
        itemBuilder: (_, index) =>
            _buildUserTile(index + 1, userProfiles[index]));
  }
}
