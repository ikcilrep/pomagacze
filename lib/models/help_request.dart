import 'user_profile.dart';

class HelpRequest {
  String? id;
  String authorID = '';
  UserProfile? author;
  String title = '';
  String description = '';
  double? locationLat;
  double? locationLng;
  DateTime? dateStart;
  DateTime? dateEnd;

  HelpRequest.empty();

  HelpRequest.fromData(dynamic data) {
    if (data != null) {
      title = data['title'] ?? '';
      description = data['description'] ?? '';
      authorID = data['author_id'] ?? '';
      if (data['author'] != null) {
        author = UserProfile.fromData(data['author']);
      }
      id = data['id'] ?? '';
      locationLat = double.tryParse(data['location_lat']?.toString() ?? '');
      locationLng = double.tryParse(data['location_lng']?.toString() ?? '');
      dateStart = DateTime.tryParse(data['date_start'] ?? '');
      dateEnd = DateTime.tryParse(data['date_end'] ?? '');
    }
  }

  Map<String, dynamic> toJSON() {
    return {
      ...(id?.isNotEmpty == true ? {'id': id} : {}),
      'author_id': authorID,
      'title': title,
      'description': description,
      'date_start': dateStart.toString(),
      'date_end': dateEnd.toString(),
      'location_lat': locationLat,
      'location_lng': locationLng,
    };
  }
}
