import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomagacze/components/event/event_list.dart';
import 'package:pomagacze/db/db.dart';
import 'package:pomagacze/state/events.dart';

class SearchEventsPage extends ConsumerStatefulWidget {
  const SearchEventsPage({Key? key}) : super(key: key);

  @override
  SearchEventsPageState createState() => SearchEventsPageState();
}

class SearchEventsPageState extends ConsumerState<SearchEventsPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    print(_searchQuery);
    return Scaffold(
        appBar: AppBar(
          title: TextField(
            decoration: const InputDecoration(hintText: 'Szukaj wydarzeń...'),
            autofocus: true,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
                ref.invalidate(filteredEventsFutureProvider);
              });
            },
          ),
          actions: [
            IconButton(onPressed: () {
              ref.invalidate(filteredEventsFutureProvider);
            }, icon: const Icon(Icons.search))
          ],
        ),
        body: EventList(
            provider: filteredEventsFutureProvider(EventFilters(
                query: _searchQuery, orderBy: EventOrder.incoming))));
  }
}
