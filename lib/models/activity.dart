import 'package:pomagacze/models/user_profile.dart';

import 'help_event.dart';

class Activity {
  late UserProfile user;
  late HelpEvent event;
  late DateTime createdAt;

  Activity(this.user, this.event, this.createdAt);

  Activity.fromData(dynamic data) {
    user = UserProfile.fromData(data['user']);
    event = HelpEvent.fromData(data['event']);
    createdAt = DateTime.tryParse(data['created_at']) ?? DateTime.parse('1984-01-01T00:00:00.000Z');
  }
}
