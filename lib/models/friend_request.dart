import 'package:pomagacze/models/user_profile.dart';

class FriendRequest {
  String senderId = '';
  UserProfile? sender;
  String targetId = '';
  UserProfile? target;

  FriendRequest.empty();

  FriendRequest.fromData(Map<String, dynamic> data) {
    senderId = data['sender_id'] ?? '';
    sender = UserProfile.fromData(data['sender'] ?? {});
    targetId = data['target_id'] ?? '';
    target = UserProfile.fromData(data['target'] ?? {});
  }
}
