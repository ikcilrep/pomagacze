import 'package:flutter/material.dart';
import 'package:pomagacze/components/event_list.dart';
import 'package:pomagacze/db/db.dart';
import 'package:pomagacze/state/events.dart';
import 'package:pomagacze/utils/constants.dart';

class MyEvents extends StatefulWidget {
  const MyEvents({Key? key}) : super(key: key);

  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            title: const Text('Moje wydarzenia'),
            bottom: TabBar(
              tabs: const [
                Tab(
                  text: 'Aktywne',
                ),
                Tab(
                  text: 'Przeszłe',
                )
              ],
              labelColor: Theme.of(context).colorScheme.onSurface,
              indicatorColor: Theme.of(context).colorScheme.primary,
            )),
        body: TabBarView(children: [
          EventList(
              provider: filteredEventsFutureProvider(EventFilters(
                  authorId: supabase.auth.currentUser?.id,
                  state: EventState.active))),
          EventList(
              provider: filteredEventsFutureProvider(EventFilters(
                  authorId: supabase.auth.currentUser?.id,
                  state: EventState.past)))
        ]),
      ),
    );
  }
}
