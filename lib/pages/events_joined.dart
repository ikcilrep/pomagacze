import 'package:flutter/material.dart';
import 'package:pomagacze/components/event_list.dart';
import 'package:pomagacze/db/db.dart';
import 'package:pomagacze/state/events.dart';
import 'package:pomagacze/utils/constants.dart';

class EventsJoined extends StatefulWidget {
  const EventsJoined({Key? key}) : super(key: key);

  @override
  State<EventsJoined> createState() => _EventsJoinedState();
}

class _EventsJoinedState extends State<EventsJoined>
    with TickerProviderStateMixin {
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
            title: const Text('Wydarzenia dołączone'),
            bottom: TabBar(
              tabs: const [
                Tab(
                  text: 'Bieżące',
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
              provider: eventsWithVolunteerFutureProvider(EventFilters(
                  volunteerId: supabase.auth.currentUser?.id,
                  state: EventState.active))),
          EventList(
              provider: eventsWithVolunteerFutureProvider(EventFilters(
                  volunteerId: supabase.auth.currentUser?.id,
                  state: EventState.past)))
        ]),
      ),
    );
  }
}
