import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomagacze/models/help_event.dart';

import '../general/error_with_action.dart';
import 'event_card.dart';

class EventList extends ConsumerStatefulWidget {
  final FutureProvider<List<HelpEvent>> provider;
  final ScrollController? scrollController;

  const EventList({Key? key, required this.provider, this.scrollController})
      : super(key: key);

  @override
  EventListState createState() => EventListState();
}

class EventListState extends ConsumerState<EventList> {
  @override
  Widget build(BuildContext context) {
    var future = ref.watch(widget.provider);

    return RefreshIndicator(
      onRefresh: () => ref.refresh(widget.provider.future),
      child: future.when(
          data: (data) => data.isNotEmpty
              ? ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 100),
                  controller: widget.scrollController,
                  itemBuilder: (context, index) => EventCard(data[index]),
                  itemCount: data.length,
                )
              : Center(
                child: ErrorWithAction(
                      action: () {
                        ref.invalidate(widget.provider);
                      },
                      actionText: 'Odśwież',
                      errorText: 'Brak wydarzeń'),
                ),
          error: (err, stack) {
            print(err);
            print(stack);
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Coś poszło nie tak...'),
                  const SizedBox(height: 5),
                  ElevatedButton(
                      onPressed: () {
                        ref.invalidate(widget.provider);
                      },
                      child: const Text('Odśwież'))
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator())),
    );
  }
}
