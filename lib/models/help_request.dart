import 'user_profile.dart';

class HelpRequest {
  String id = '';
  String authorID = '';
  UserProfile? author;
  String title = '';
  String description = '';
  double? locationLat;
  double? locationLng;


  HelpRequest.empty();

  HelpRequest.fromData(dynamic data) {
    if (data != null) {
      title = data['title'] ?? '';
      description = data['description'] ?? '';
      authorID = data['author_id'] ?? '';
      if(data['author'] != null) author = UserProfile.fromData(data['author'] ?? {});
      id = data['id'] ?? '';
      locationLat = double.tryParse(data['location_lat'].toString() ?? '');
      locationLng = double.tryParse(data['location_lng'].toString() ?? '');
    }
  }
}