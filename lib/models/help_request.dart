import 'user_profile.dart';

class HelpRequest {
  String? id;
  String authorId = '';
  UserProfile? author;
  String title = '';
  String description = '';
  DateTime? dateStart;
  DateTime? dateEnd;

  double? latitude;
  double? longitude;
  String? placeName;

  HelpRequest.empty();

  HelpRequest.fromData(dynamic data) {
    if (data != null) {
      title = data['title'] ?? '';
      description = data['description'] ?? '';
      authorId = data['author_id'] ?? '';
      if (data['author'] != null) {
        author = UserProfile.fromData(data['author']);
      }
      id = data['id'] ?? '';
      latitude = data['latitude'];
      longitude = data['longitude'];
      placeName = data['place_name'];
      dateStart = DateTime.tryParse(data['date_start'] ?? '');
      dateEnd = DateTime.tryParse(data['date_end'] ?? '');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      ...(id?.isNotEmpty == true ? {'id': id} : {}),
      'author_id': authorId,
      'title': title,
      'description': description,
      'date_start': dateStart.toString(),
      'date_end': dateEnd.toString(),
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'place_name': placeName,
    };
  }
}
