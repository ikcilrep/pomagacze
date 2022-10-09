import 'package:gender_picker/source/enums.dart';
import 'package:open_location_picker/open_location_picker.dart';
import 'package:pomagacze/utils/gender_serializing.dart';

class UserProfile {
  String? name;
  String? avatarURL;
  DateTime? birthDate;
  Gender? gender;
  double? latitude;
  double? longitude;
  String? placeName;

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
      return FormattedLocation.fromLatLng(lat: latitude!, lon: longitude!, displayName: placeName!);
    }
    return null;
  }

  UserProfile.empty();

  UserProfile.fromData(dynamic data) {
    if (data != null) {
      name = data['name'];
      gender = GenderSerializing.deserialize(data['gender']);
      birthDate = DateTime.tryParse(data['birth_date'] ?? '');
      latitude = data['latitude'];
      longitude = data['latitude'];
      placeName = data['placeName'];
    }
  }
}
