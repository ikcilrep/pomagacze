import 'user_profile.dart';

class Volunteer {
  late final String userId;
  late final String eventId;

  UserProfile? profile;

  Volunteer({required this.userId, required this.eventId});

  Volunteer.fromData(dynamic data) {
    userId = data['user_id'] ?? '';
    eventId = data['event_id'] ?? '';
    if (data['profile'] != null) {
      profile = UserProfile.fromData(data['profile']);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'event_id': eventId,
    };
  }
}
