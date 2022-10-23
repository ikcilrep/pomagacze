import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pomagacze/models/help_event.dart';

class VolunteersBadge extends StatelessWidget {
  final HelpEvent event;

  const VolunteersBadge({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
                border: Border.all(color: Colors.black12, width: 0),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                child: Row(
                  children: [
                    const Icon(Icons.group, color: Colors.black87, size: 20),
                    const SizedBox(width: 5),
                    Text(
                      "${event.volunteers.length}/${event.maximalNumberOfVolunteers}",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(color: Colors.black87),
                    ),
                  ],
                ),
              ),
            )));
  }
}