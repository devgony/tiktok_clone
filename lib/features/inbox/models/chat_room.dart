import 'package:tiktok_clone/features/users/models/user_profile_model.dart';

class ChatRoomModel {
  final UserProfileModel currentUser;
  final UserProfileModel otherUser;
  final String lastMessage;
  final int updatedAt;

  ChatRoomModel({
    required this.currentUser,
    required this.otherUser,
    required this.lastMessage,
    required this.updatedAt,
  });

  ChatRoomModel.fromJson(Map<String, dynamic> json)
      : currentUser = UserProfileModel.fromJson(json['currentUser']),
        otherUser = UserProfileModel.fromJson(json['otherUser']),
        lastMessage = json['lastMessage'],
        updatedAt = json['updatedAt'];

  Map<String, dynamic> toJson() {
    return {
      "currentUser": currentUser,
      "otherUser": otherUser,
      "lastMessage": lastMessage,
      "updatedAt": updatedAt,
    };
  }
}
