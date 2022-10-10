import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:pomagacze/models/help_event.dart';
import 'package:pomagacze/pages/event_details.dart';

class EventCard extends StatefulWidget {
  final HelpEvent request;

  const EventCard(this.request, {Key? key}) : super(key: key);

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  @override
  Widget build(BuildContext context) {
    return OpenContainer<bool>(
        transitionType: ContainerTransitionType.fadeThrough,
        openBuilder: (BuildContext context, VoidCallback _) =>
            EventDetails(widget.request),
        tappable: false,
        closedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        closedElevation: 1.5,
        // transitionDuration: const Duration(seconds: 2),
        closedBuilder: (_, openContainer) {
          return Card(
              elevation: 1.5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: openContainer,
                child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.request.title,
                            style: Theme.of(context).textTheme.bodyLarge),
                        Text(widget.request.description,
                            style: Theme.of(context).textTheme.bodyText2)
                      ],
                    )),
              ));
        });
  }
}
