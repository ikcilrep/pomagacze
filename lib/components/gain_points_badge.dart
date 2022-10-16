import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pomagacze/models/help_event.dart';
class PointsBadge extends StatelessWidget {
  final HelpEvent event;

  const PointsBadge({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error.withOpacity(0.8),
                border: Border.all(color: Colors.black12, width: 0),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: Row(
                  children: [
                    const Icon(Icons.favorite, color: Colors.white, size: 20),
                    const SizedBox(width: 5),
                    Text(
                      "+${event.points}",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            )));
  }
}