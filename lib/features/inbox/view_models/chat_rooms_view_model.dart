import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/inbox/repos/chat_rooms_repo.dart';

import '../../authentication/repos/authentication_repo.dart';
import '../models/chat_room.dart';

class ChatRoomsViewModel extends AsyncNotifier<void> {
  late final ChatRoomsRepo _repo;
  late final String chatRoomId;
  // final List<ChatRoomModel> _list = [];

  // Future<List<ChatRoomModel>> _fetchChatRooms() async {
  //   final user = ref.read(authRepo).user;

  //   return _repo.fetchChatRooms(user!.uid);
  // }

  Future<String> createChatRoom(String otherUid) async {
    final user = ref.read(authRepo).user;
    state = const AsyncValue.loading();

    return await _repo.createChatRoom(user!.uid, otherUid);
  }

  @override
  FutureOr<void> build() {
    // _repo = ref.read(messagesRepo);
    _repo = ref.read(chatRoomsRepo);
    // _list = await _fetchChatRooms();

    return chatRoomId;
  }
}

final chatRoomsProvider = AsyncNotifierProvider<ChatRoomsViewModel, void>(
  () => ChatRoomsViewModel(),
);

final chatRoomsStreamProvider = StreamProvider.autoDispose<List<ChatRoomModel>>(
  (ref) async* {
    final repo = ref.read(chatRoomsRepo);
    final uid = ref.read(authRepo).user!.uid;
    final db = FirebaseFirestore.instance;

    print("here");

    final user = await db.collection("users").doc(uid).get();
    final List<DocumentReference<Map<String, dynamic>>> chatRooms =
        user.get("chatRooms");

    final a = chatRooms.map((chatRoomRef) async {
      final chatRoom = (await chatRoomRef.get());
      final currentUser = await getRefData(chatRoom, "currentUserRef");
      final otherUser = await getRefData(chatRoom, "otherUserRef");
      final Map<String, dynamic> lastMessage =
          await getRefData(chatRoom, "lastMessage");
      final int updatedAt = await lastMessage['createdAt'];
      final String text = await lastMessage['text'];

      return ChatRoomModel(
        currentUser: currentUser,
        otherUser: otherUser,
        lastMessage: text,
        updatedAt: updatedAt,
      );
    }).toList();
    // }
    // chatRooms.map((chatRoomRef) async {
    //   final a = await db.collection("chat_rooms").doc(chatRoomRef).get();

    //   print(a.data());
    // });

    // final a = db.collection("users").doc(user!.uid).get().then((value) {
    //   final List<dynamic> chatRooms = value.get("chatRooms");
    //   chatRooms.map((chatRoom) {
    //     print(chatRoom);

    //     return null;
    //   });

    //   print(":+:+:$chatRooms");
    // });
    // .snapshots().map((event) {
    //   final chatRooms = event.get("chatRooms");

    //   print(":+:+:$chatRooms");
    // });

    // throw UnimplementedError();
  },
);

Future<dynamic> getRefData(
    DocumentSnapshot<Map<String, dynamic>> document, String ref,
    [String? field]) async {
  final documentSnapshot =
      (await (document.get(ref) as DocumentReference<Map<String, dynamic>>)
          .get());

  if (field != null) {
    return documentSnapshot.get(field).data();
  }

  return documentSnapshot.data();
}
