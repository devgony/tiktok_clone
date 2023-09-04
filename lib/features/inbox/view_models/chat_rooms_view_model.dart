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
    final List<DocumentReference> chatRooms = user
        .get("chatRooms")
        .cast<DocumentReference>(); // TODO: not cast but generic

    for (final chatRoomRef in chatRooms) {
      final chatRoom = (await chatRoomRef.get());
      final currentUser = await getRefData(chatRoom, 'currentUserRef');
      final otherUser = await getRefData(chatRoom, 'otherUserRef');
      final lastMessage =
          (await (chatRoom.get('lastMessage') as DocumentReference).get())
              .data();

      // how to convert to map?
      final updatedAt = lastMessage != null ? lastMessage['createdAt'] : null;

      // final chatRoom = await db.collection("chat_rooms").doc(chatRoomRef).get();

      // final chatRoomData = chatRoom.data() as Map<String, dynamic>;
      // final currentUserRef =
      //     chatRoomData['currentUserRef'] as DocumentReference;
      // final otherUserRef = chatRoomData['otherUserRef'] as DocumentReference;
      // final lastMessageRef =
      //     chatRoomData['lastMessageRef'] as DocumentReference;
      // chatRoomData['currentUser'] = (await currentUserRef.get()).data();
      // chatRoomData['otherUser'] = (await otherUserRef.get()).data();
      // final lastMessage =
      //     (await lastMessageRef.get()).data() as Map<String, dynamic>;
      // chatRoomData['lastMessage'] = lastMessage['text'];
      // chatRoomData['updatedAt'] = lastMessage['createdAt'];
      // final chatRoomModel = ChatRoomModel.fromJson(chatRoomData);

      // print(chatRoomModel);

      // yield chatRoomModel;
    }
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

Future<Object?> getRefData(
    DocumentSnapshot<Object?> document, String ref) async {
  return (await (document.get(ref) as DocumentReference).get()).data();
}
