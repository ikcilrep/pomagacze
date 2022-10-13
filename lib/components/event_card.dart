import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pomagacze/models/help_event.dart';
import 'package:pomagacze/pages/event_details.dart';
import 'package:pomagacze/utils/constants.dart';
import 'package:pomagacze/utils/date_extensions.dart';
import 'package:pomagacze/utils/string_extensions.dart';

class EventCard extends StatefulWidget {
  final HelpEvent event;

  const EventCard(this.event, {Key? key}) : super(key: key);

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  final _dateFormat = DateFormat('dd MMM');
  final _dateFormatHour = DateFormat('dd MMM HH:mm');

  @override
  Widget build(BuildContext context) {
    return OpenContainer<bool>(
        tappable: false,
        transitionType: ContainerTransitionType.fadeThrough,
        transitionDuration: const Duration(milliseconds: 350),
        openBuilder: (BuildContext context, VoidCallback _) =>
            EventDetails(widget.event),
        closedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        closedElevation: 1.5,
        // transitionDuration: const Duration(seconds: 2),
        closedBuilder: (_, openContainer) {
          return Card(
              elevation: 1.5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: openContainer,
                child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoMessage(),
                        Text(widget.event.title,
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text(
                          widget.event.description,
                          style: Theme.of(context).textTheme.bodyText2,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 15),
                        Row(children: [
                          Icon(Icons.event,
                              size: 15,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.8)),
                          const SizedBox(width: 4),
                          SizedBox(
                            width: 86,
                            child: Text(_getDateString(),
                                style: Theme.of(context).textTheme.caption),
                          ),
                          const SizedBox(width: 15),
                          Icon(Icons.location_pin,
                              size: 15,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.8)),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              widget.event.addressShort.orDefault('???'),
                              style: Theme.of(context).textTheme.caption,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Icon(Icons.local_fire_department_sharp,
                              size: 15,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.8)),
                          const SizedBox(width: 4),
                          SizedBox(
                              width: 20,
                              child: Text(widget.event.points.toString(),
                                  style: Theme.of(context).textTheme.caption))
                        ])
                      ],
                    )),
              ));
        });
  }

  String _getDateString() {
    var start = widget.event.dateStart!;
    var end = widget.event.dateEnd!;

    if (start.isSameDate(end)) {
      return _dateFormatHour.format(start);
    }

    return '${_dateFormat.format(start)} - ${_dateFormat.format(end)}';
  }

  String? _getInfoMessage() {
    if (widget.event.volunteers.any((x) => x.userId == supabase.auth.currentUser!.id) ==
        true) {
      return 'Bierzesz udział w tym wydarzeniu';
    }
    return null;
  }

  Widget _buildInfoMessage() {
    var message = _getInfoMessage();

    if (message == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
      child: Text(
        message.toUpperCase(),
        style: Theme.of(context)
            .textTheme
            .overline
            ?.copyWith(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}
