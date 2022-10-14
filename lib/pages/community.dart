import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomagacze/pages/activities.dart';
import 'package:pomagacze/pages/leaderboard.dart';

class CommunityPage extends ConsumerStatefulWidget {
  const CommunityPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => CommunityPageState();
}

class CommunityPageState extends ConsumerState<CommunityPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        TabBar(
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
        ),
        const Expanded(
            child: TabBarView(children: [LeaderboardPage(), ActivitiesPage()]))
      ]),
    );
  }
}
