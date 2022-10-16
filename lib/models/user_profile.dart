import 'package:age_calculator/age_calculator.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:open_location_picker/open_location_picker.dart';
import 'package:pomagacze/utils/gender_serializing.dart';

class UserProfile {
  String id = '';
  String? name;
  String? avatarURL;
  DateTime? birthDate;
  Gender? gender;
  double? latitude;
  double? longitude;
  String? placeName;
  int xp = 0;
  int xpThisWeek = 0;
  int xpThisMonth = 0;

  int get age => AgeCalculator.age(birthDate ?? DateTime.now()).years;

  set location(FormattedLocation? value) {
    if (value != null) {
      latitude = value.lat;
      longitude = value.lon;
      placeName = value.displayName;
    } else {
      latitude = null;
      longitude = null;
      placeName = null;
    }
  }

  FormattedLocation? get location {
    if (latitude != null && longitude != null && placeName != null) {
      return FormattedLocation.fromLatLng(
          lat: latitude!, lon: longitude!, displayName: placeName!);
    }
    return null;
  }

  UserProfile.empty();

  UserProfile.fromData(dynamic data) {
    if (data != null) {
      id = data['id'] ?? '';
      name = data['name'];
      avatarURL = data['avatar_url'];
      gender = GenderSerializing.deserialize(data['gender']);
      birthDate = DateTime.tryParse(data['birth_date'] ?? '');
      latitude = data['latitude'];
      longitude = data['longitude'];
      placeName = data['place_name'];
      xp = data['xp'] ?? 0;
      xpThisWeek = data['xp_this_week'] ?? 0;
      xpThisMonth = data['xp_this_month'] ?? 0;
    }
  }

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'avatar_url': avatarURL,
        'birth_date': birthDate?.toIso8601String().toString(),
        'gender': gender?.serialize().toString(),
        'latitude': latitude,
        'longitude': longitude,
        'place_name': placeName,
        'xp': xp,
        'xp_this_week': xpThisWeek,
        'xp_this_month': xpThisMonth
      };
}
