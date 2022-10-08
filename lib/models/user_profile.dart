import 'package:gender_picker/source/enums.dart';
import 'package:pomagacze/utils/gender_serializing.dart';

class UserProfile {
  String? name;
  DateTime? birthDate;
  Gender? gender;

  UserProfile.empty();

  UserProfile.fromData(dynamic data) {
    if (data != null) {
      name = data['name'];
      gender = deserializeGender(data['gender']);
      birthDate = DateTime.tryParse(data['birth_date']);
    }
  }
}