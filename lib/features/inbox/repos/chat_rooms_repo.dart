import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/inbox/models/chat_room.dart';

class ChatRoomsRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<ChatRoomModel>> fetchChatRooms(String uid) {
    final a =
        _db.collection("users").doc(uid).collection("chatRooms").snapshots();
    // .then((value) => print(value.docs.first.data()));

    // .snapshots()
    // .map((event) => print(event));

    // a.then((value) => print(value.data()));

    return _db
        .collection("users")
        .doc(uid)
        .collection("chatRooms")
        // .orderBy("updatedAt",
        //     descending:
        //         true) // TODO: should be sorted by updatedAt so that save duplicated date?
        .snapshots()
        .asyncMap((event) async {
      final chatRooms = <ChatRoomModel>[];
      // for (final doc in event.docs) {
      //   final chatRoomData = doc.data();
      //   final chatRoomRef = chatRoomData['ref'] as DocumentReference;
      //   final chatRoomSnapshot = await chatRoomRef.get();
      //   final chatRoomMap = chatRoomSnapshot.data() as Map<String, dynamic>;
      //   final currentUserRef =
      //       chatRoomMap['currentUserRef'] as DocumentReference;
      //   final otherUserRef = chatRoomMap['otherUserRef'] as DocumentReference;
      //   final lastMessageRef =
      //       chatRoomMap['lastMessageRef'] as DocumentReference;
      //   chatRoomMap['currentUser'] = (await currentUserRef.get()).data();
      //   chatRoomMap['otherUser'] = (await otherUserRef.get()).data();
      //   final lastMessage =
      //       (await lastMessageRef.get()).data() as Map<String, dynamic>;
      //   chatRoomMap['lastMessage'] = lastMessage['text'];
      //   // chatRoomMap['updatedAt'] = lastMessage['createdAt'];
      //   final chatRoom = ChatRoomModel.fromJson(chatRoomMap);
      //   chatRooms.add(chatRoom);
      // }

      print('chatRooms: $chatRooms');

      return chatRooms;
    });
  }

  FutureOr<String> createChatRoom(
      String currentUserId, String otherUserId) async {
    final currentUserRef = _db.collection("users").doc(currentUserId);
    final currentUser = await currentUserRef.get();
    final otherUserRef = _db.collection("users").doc(otherUserId);
    final otherUser = await otherUserRef.get();

    final createdChatRoom = await _db
        .collection("chatRooms")
        .add({}); // TODO: currently it is useless

    final currentUserChatRooms = currentUserRef.collection("chatRooms");
    final otherUserChatRooms = otherUserRef.collection("chatRooms");

    final now = DateTime.now().millisecondsSinceEpoch;
    await currentUserChatRooms.doc(createdChatRoom.id).set({
      "otherUser": otherUser.data(),
      "updatedAt": now,
    });

    await otherUserChatRooms.doc(createdChatRoom.id).set({
      "otherUser": currentUser.data(),
      "updatedAt": now,
    });

    return createdChatRoom.id;
  }
}

final chatRoomsRepo = Provider(
  (ref) => ChatRoomsRepo(),
);
