import 'package:pomagacze/models/user_profile.dart';
import 'help_event.dart';

class Activity {
  final UserProfile user;
  final HelpEvent event;
  final DateTime createdAt;

  Activity(this.user, this.event, this.createdAt);
}