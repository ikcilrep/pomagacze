import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pomagacze/models/activity.dart';
import 'package:pomagacze/utils/date_extensions.dart';

class ActivityTile extends StatelessWidget {
  final Activity activity;

  const ActivityTile(this.activity, {super.key});

  @override
  Widget build(BuildContext context) {
    throw ListTile(
        title:
            Text('${activity.user.name} dołączył do "${activity.event.title}"'),
        subtitle: Text(activity.createdAt.displayable()));
  }
}
