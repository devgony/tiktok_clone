import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/inbox/models/chat_room.dart';

import '../../authentication/repos/authentication_repo.dart';

class ChatRoomsRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<ChatRoomModel>> fetchChatRooms(String uid) => _db
          .collection("users")
          .doc(uid)
          .collection("chat_rooms")
          // .orderBy("updatedAt",
          //     descending:
          //         true) // TODO: should be sorted by updatedAt so that save duplicated date?
          .snapshots()
          .asyncMap((event) async {
        final chatRooms = <ChatRoomModel>[];
        for (final doc in event.docs) {
          final chatRoomData = doc.data();
          final chatRoomRef = chatRoomData['ref'] as DocumentReference;
          final chatRoomSnapshot = await chatRoomRef.get();
          final chatRoomMap = chatRoomSnapshot.data() as Map<String, dynamic>;
          final currentUserRef =
              chatRoomMap['currentUserRef'] as DocumentReference;
          final otherUserRef = chatRoomMap['otherUserRef'] as DocumentReference;
          final lastMessageRef =
              chatRoomMap['lastMessageRef'] as DocumentReference;
          chatRoomMap['currentUser'] = (await currentUserRef.get()).data();
          chatRoomMap['otherUser'] = (await otherUserRef.get()).data();
          final lastMessage =
              (await lastMessageRef.get()).data() as Map<String, dynamic>;
          chatRoomMap['lastMessage'] = lastMessage['text'];
          // chatRoomMap['updatedAt'] = lastMessage['createdAt'];
          final chatRoom = ChatRoomModel.fromJson(chatRoomMap);
          chatRooms.add(chatRoom);
        }

        return chatRooms;
      });

  FutureOr<String> createChatRoom(
      String currentUserId, String otherUserId) async {
    final currentUser = await _db.collection("users").doc(currentUserId).get();
    final otherUser = await _db.collection("users").doc(otherUserId).get();
    final chatRoom = {
      "currentUser": currentUser.data(),
      "otherUser": otherUser.data(),
      "lastMessage": "",
      "updatedAt": DateTime.now().millisecondsSinceEpoch,
    };

    final createdChatRoom = await _db.collection("chat_rooms").add(chatRoom);

    final currentUserRef = _db.collection("users").doc(currentUserId);
    final currentUserDoc = await currentUserRef.get();
    final currentUserChatRooms =
        List<String>.from(currentUserDoc.data()?['chatRooms'] ?? []);
    currentUserChatRooms.add(createdChatRoom.id);
    await currentUserRef.update({'chatRooms': currentUserChatRooms});

    final otherUserRef = _db.collection("users").doc(otherUserId);
    final otherUserDoc = await otherUserRef.get();
    final otherUserChatRooms =
        List<String>.from(otherUserDoc.data()?['chatRooms'] ?? []);
    otherUserChatRooms.add(createdChatRoom.id);
    await otherUserRef.update({'chatRooms': otherUserChatRooms});

    return createdChatRoom.id;
  }
}

final chatRoomsRepo = Provider(
  (ref) => ChatRoomsRepo(),
);

final chatRoomsStreamProvider = StreamProvider.autoDispose<List<ChatRoomModel>>(
  (ref) {
    final repo = ref.read(chatRoomsRepo);
    final user = ref.read(authRepo).user;

    return repo.fetchChatRooms(user!.uid);
  },
);
