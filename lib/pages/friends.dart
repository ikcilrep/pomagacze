import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomagacze/pages/activities.dart';
import 'package:pomagacze/pages/manage_friends.dart';

class FriendsPage extends ConsumerStatefulWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => FriendsPageState();
}

class FriendsPageState extends ConsumerState<FriendsPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(
          color: Theme.of(context).colorScheme.surface,
          child: TabBar(
            tabs: const [
              Tab(
                text: 'Aktualności',
              ),
              Tab(
                text: 'Znajomi',
              ),
            ],
            labelColor: Theme.of(context).colorScheme.onSurface,
            indicatorColor: Theme.of(context).colorScheme.primary,
          ),
        ),
        const Expanded(
            child:
                TabBarView(children: [ActivitiesPage(), ManageFriendsPage()]))
      ]),
    );
  }
}
