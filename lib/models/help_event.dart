import 'package:intl/intl.dart';
import 'package:pomagacze/utils/constants.dart';

import 'user_profile.dart';
import 'volunteer.dart';

class HelpEvent {
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
  int points = 0;

  double? latitude;
  double? longitude;
  String? addressShort;
  String? addressFull;

  List<Volunteer> volunteers = [];

  bool get isMinimalAgeSpecified => minimalAge != null && minimalAge != minimalVolunteerAge;
  bool get isMaximalAgeSpecified => maximalAge != null && maximalAge != maximalVolunteerAge;

  String? get formattedDateStart => dateStart == null ? null : _formatDate(dateStart!);
  String? get formattedDateEnd => dateStart == null ? null : _formatDate(dateEnd!);

  String _formatDate(DateTime date) {
    return DateFormat('dd.MM.yyyy - kk:mm').format(date);
  }


  HelpEvent.empty();

  HelpEvent.fromData(dynamic data) {
    if (data != null) {
      title = data['title'] ?? '';
      description = data['description'] ?? '';
      authorId = data['author_id'] ?? '';
      author = UserProfile.fromData(data['author']);
      if (data['author'] != null) {
        author = UserProfile.fromData(data['author']);
      }
      id = data['id'] ?? '';
      latitude = castToDoubleIfInteger(data['latitude']);
      longitude = castToDoubleIfInteger(data['longitude']);
      addressShort = data['address_short'];
      addressFull = data['address_full'];
      dateStart = DateTime.tryParse(data['date_start'] ?? '');
      dateEnd = DateTime.tryParse(data['date_end'] ?? '');
      minimalAge = parseIntIfString(data['minimal_age']);
      maximalAge = parseIntIfString(data['maximal_age']);
      minimalNumberOfVolunteers =
          parseIntIfString(data['minimal_number_of_volunteers']);
      maximalNumberOfVolunteers =
          parseIntIfString(data['maximal_number_of_volunteers']);
      points = parseIntIfString(data['points']) ?? 0;
      if(data['volunteers'] is List) {
        volunteers = (data['volunteers'] as List).map((x) => Volunteer.fromData(x)).toList();
      } else {
        volunteers = [];
      }
    }
  }

  int? parseIntIfString(number) =>
      (number is int?) || number is int
          ? number
          : int.tryParse(number);

  double? castToDoubleIfInteger(number) =>
      number is int ? number.toDouble() : number;

  Map<String, dynamic> toJson() {
    return {
      ...(id?.isNotEmpty == true ? {'id': id} : {}),
      'author_id': authorId,
      'title': title,
      'description': description,
      'date_start': dateStart?.toString(),
      'date_end': dateEnd?.toString(),
      'latitude': latitude,
      'longitude': longitude,
      'minimal_age': minimalAge,
      'maximal_age': maximalAge,
      'minimal_number_of_volunteers': minimalNumberOfVolunteers,
      'maximal_number_of_volunteers': maximalNumberOfVolunteers,
      'address_short': addressShort,
      'address_full': addressFull,
      'points': points
    };
  }
}
