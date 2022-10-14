import 'user_profile.dart';

class Volunteer {
  late final String userId;
  late final String eventId;
  late final DateTime createdAt;

  UserProfile? profile;

  Volunteer({required this.userId, required this.eventId});

  Volunteer.fromData(dynamic data) {
    userId = data['user_id'] ?? '';
    eventId = data['event_id'] ?? '';
    createdAt = DateTime.parse(data['created_at'] ?? '');
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
