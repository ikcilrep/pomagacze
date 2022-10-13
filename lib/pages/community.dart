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
    final mostExperiencedUsers = ref.watch(mostExperiencedUsersProvider(10));
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
          mostExperiencedUsers.hasValue
              ? ListView.builder(
                  itemCount: mostExperiencedUsers.value!.length,
                  itemBuilder: (_, index) =>
                      _buildUserTile(index + 1, mostExperiencedUsers.value![index]))
              : Container(),
          Container()
        ]),
      ),
    );
  }
}
