import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class PointsBadge extends StatelessWidget {
  const PointsBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
                width: 65,
                height: 40,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error.withOpacity(0.8),
                    border: Border.all(
                        color: Colors.black12,
                        width: 0
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                      children: [
                        Icon(Icons.local_fire_department,
                            color: Colors.white,
                            size: 20),
                        Text(
                          "68,8",
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ))));
  }
}