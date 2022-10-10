class Volunteer {
  late final String userId;
  late final String eventId;

  Volunteer({required this.userId, required this.eventId});

  Volunteer.fromData(dynamic data) {
    userId = data['user_id'];
    eventId = data['event_id'];
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'event_id': eventId,
    };
  }


}
