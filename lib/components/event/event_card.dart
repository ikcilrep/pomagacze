import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pomagacze/models/help_event.dart';
import 'package:pomagacze/pages/events/event_details.dart';
import 'package:pomagacze/state/friendships.dart';
import 'package:pomagacze/utils/constants.dart';
import 'package:pomagacze/utils/date_extensions.dart';
import 'package:pomagacze/utils/string_extensions.dart';

import 'gain_points_badge.dart';
import 'volunteers_badge.dart';

class EventCard extends ConsumerStatefulWidget {
  final HelpEvent event;

  const EventCard(this.event, {Key? key}) : super(key: key);

  @override
  ConsumerState<EventCard> createState() => _EventCardState();
}

class _EventCardState extends ConsumerState<EventCard> {
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
              elevation: 0,
              color: Theme.of(context)
                  .colorScheme
                  .secondaryContainer
                  .withOpacity(0.12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.54),
                      width: 1)),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: openContainer,
                child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildInfoMessage(),
                        Text(widget.event.title,
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 5),
                        Text(
                          widget.event.description,
                          style: Theme.of(context).textTheme.bodyText2,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                        if (widget.event.imageUrl != null)
                          ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: ConstrainedBox(
                                  constraints:
                                      const BoxConstraints(maxHeight: 250),
                                  child: Stack(children: <Widget>[
                                    SizedBox(
                                      width: double.infinity,
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(0),
                                          child: ConstrainedBox(
                                              constraints: const BoxConstraints(
                                                  maxHeight: 250),
                                              child: Image.network(
                                                widget.event.imageUrl!,
                                                fit: BoxFit.fitWidth,
                                              ))),
                                    ),
                                    Positioned(
                                        right: 10,
                                        top: 10,
                                        child:
                                            PointsBadge(event: widget.event)),
                                    Positioned(
                                        left: 10,
                                        top: 10,
                                        child: VolunteersBadge(
                                            event: widget.event))
                                  ]))),
                        const SizedBox(height: 15),
                        Row(children: [
                          Icon(Icons.event,
                              size: 15,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.8)),
                          const SizedBox(width: 3),
                          Text(_getDateString(),
                              style: Theme.of(context).textTheme.caption),
                          const SizedBox(width: 12),
                          Icon(Icons.location_pin,
                              size: 15,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.8)),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              widget.event.addressShort.orDefault('???'),
                              style: Theme.of(context).textTheme.caption,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                          ),
                          if (widget.event.imageUrl == null)
                            Row(
                              children: [
                                Icon(Icons.group,
                                    size: 15,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.8)),
                                const SizedBox(width: 3),
                                Text(
                                    "${widget.event.volunteers.length}/${widget.event.maximalNumberOfVolunteers}",
                                    style: Theme.of(context).textTheme.caption,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ),
                              ],
                            ),
                          if (widget.event.imageUrl == null)
                            Row(
                              children: [
                                const SizedBox(width: 5),
                                Icon(Icons.favorite,
                                    size: 15,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.8)),
                                const SizedBox(width: 3),
                                Text(
                                  "${widget.event.points}",
                                  style: Theme.of(context).textTheme.caption,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                ),
                              ],
                            ),
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
    var friendIds = ref.read(friendsIdsProvider).valueOrNull ?? [];
    var friendVolunteers =
        widget.event.volunteers.where((x) => friendIds.contains(x.userId));

    final isCurrentUserParticipating = widget.event.volunteers
        .any((x) => x.userId == supabase.auth.currentUser!.id);

    if (isCurrentUserParticipating && friendVolunteers.length == 1) {
      return 'Ty i ${friendVolunteers.first.profile?.name} bierzecie udzia??';
    }

    if (isCurrentUserParticipating && friendVolunteers.length > 1) {
      return 'Ty i ${friendVolunteers.length} znajomych bierzecie udzia??';
    }

    if (friendVolunteers.length == 1) {
      return '${friendVolunteers.first.profile?.name} bierze udzia??';
    }

    if (friendVolunteers.length > 1) {
      return '${friendVolunteers.length} znajomych bierze udzia??';
    }

    if (isCurrentUserParticipating == true) {
      return 'Bierzesz udzia?? w tym wydarzeniu';
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
