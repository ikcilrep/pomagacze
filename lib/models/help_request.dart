import 'user_profile.dart';

class HelpRequest {
  String? id;
  String authorId = '';
  UserProfile? author;
  String title = '';
  String description = '';
  DateTime? dateStart;
  DateTime? dateEnd;
  int? minimalNumberOfVolunteers;
  int? maximalNumberOfVolunteers;
  int? minimalAge;
  int? maximalAge;

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
      latitude = castToDoubleIfInteger(data['latitude']);
      longitude = castToDoubleIfInteger(data['longitude']);
      placeName = data['place_name'];
      dateStart = DateTime.tryParse(data['date_start'] ?? '');
      dateEnd = DateTime.tryParse(data['date_end'] ?? '');
      minimalAge = parseIntIfString(data['minimalAge']);
      maximalAge = parseIntIfString(data['maximalAge']);
      minimalNumberOfVolunteers = parseIntIfString(data['minimal_number_of_volunteers']);
      maximalNumberOfVolunteers = parseIntIfString(data['maximal_number_of_volunteers']);
    }
  }

  int? parseIntIfString(number) => number is int?
        ?number
        : int.tryParse(number);

  double? castToDoubleIfInteger(number) =>
      number is int ? number.toDouble() : number;

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
      'minimal_age': minimalAge,
      'maximal_age': maximalAge,
      'minimal_number_of_volunteers': minimalNumberOfVolunteers,
      'maximal_number_of_volunteers': maximalNumberOfVolunteers,
      'place_name': placeName,
    };
  }
}
