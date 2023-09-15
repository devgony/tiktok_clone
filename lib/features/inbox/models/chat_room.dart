import 'package:tiktok_clone/features/users/models/user_profile_model.dart';

class ChatRoomModel {
  final String id;
  final UserProfileModel otherUser;
  final String? lastMessage;
  final int? updatedAt;

  ChatRoomModel({
    required this.id,
    required this.otherUser,
    required this.lastMessage,
    required this.updatedAt,
  });

  ChatRoomModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        otherUser = UserProfileModel.fromJson(json['otherUser']),
        lastMessage = json['lastMessage'],
        updatedAt = json['updatedAt'];

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "otherUser": otherUser,
      "lastMessage": lastMessage,
      "updatedAt": updatedAt,
    };
  }
}
