import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/inbox/models/message.dart';

class MessagesRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> sendMessage({
    required MessageModel message,
    required String chatId,
  }) async {
    final lastMessageRef =
        await _db.collection("chatRooms").doc(chatId).collection("texts").add(
              message.toJson(),
            );

    await _db.collection("chatRooms").doc(chatId).update(
      {
        "lastMessageRef": lastMessageRef,
      },
    );
  }
}

final messagesRepo = Provider(
  (ref) => MessagesRepo(),
);
