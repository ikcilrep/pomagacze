import 'user_profile.dart';

class HelpRequest {
  int id = 0;
  UserProfile? author;
  String? title;
  String? description;

  HelpRequest.empty();

  HelpRequest.fromData(dynamic data) {
    if (data != null) {
      title = data['title'] ?? '';
      description = data['description'] ?? '';
      author = UserProfile.fromData(data['author']);
      id = data['id'] ?? 0;
    }
  }
}