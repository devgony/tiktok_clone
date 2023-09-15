import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/inbox/models/message.dart';

class MessagesRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> sendMessage({
    required MessageModel message,
    required String chatId,
    required String currentUserId,
  }) async {
    try {
      await _db.collection("chatRooms").doc(chatId).collection("texts").add(
            message.toJson(),
          );

      final users = _db.collection("users");

      final currentUserChatRoomsRef =
          users.doc(currentUserId).collection("chatRooms").doc(chatId);

      final now = DateTime.now().millisecondsSinceEpoch;
      await currentUserChatRoomsRef
          .update({"lastMessage": message.text, "updatedAt": now});

      final currentUserChatRooms = await currentUserChatRoomsRef.get();

      final Map<String, dynamic> otherUser =
          currentUserChatRooms.get("otherUser");
      final String otherUserId = otherUser["uid"];
      final otherUserChatRoomsRef =
          users.doc(otherUserId).collection("chatRooms").doc(chatId);

      await otherUserChatRoomsRef.update({
        "lastMessage": message.text,
        "updatedAt": now,
      });
    } catch (e) {
      print("error");
      print(e);
    }
  }
}

final messagesRepo = Provider(
  (ref) => MessagesRepo(),
);
