import 'package:gender_picker/source/enums.dart';

extension GenderSerializing on Gender {
  String serialize() {
    switch(this) {
      case Gender.Male:
        return "male";
      case Gender.Female:
        return "female";
      case Gender.Others:
        return "other";
    }
  }
}

Gender? deserializeGender(String serializedGender) {
  switch (serializedGender) {
    case "male":
      return Gender.Male;
    case "female":
      return Gender.Female;
    case "other":
      return Gender.Others;
    default:
      return null;
  }
}