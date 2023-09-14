import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/inbox/repos/chat_rooms_repo.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';

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
    // TODO: what should i return here?
    // _repo = ref.read(messagesRepo);
    _repo = ref.read(chatRoomsRepo);
    // _list = await _fetchChatRooms();

    // return chatRoomId;
  }
}

final chatRoomsProvider = AsyncNotifierProvider<ChatRoomsViewModel, void>(
  () => ChatRoomsViewModel(),
);

final chatRoomsStreamProvider =
    StreamProvider.autoDispose<List<ChatRoomModel>>((ref) {
  // final repo = ref.read(chatRoomsRepo);
  final uid = ref.read(authRepo).user!.uid;
  final db = FirebaseFirestore.instance;
  final user =
      db.collection("users").doc(uid).snapshots().asyncMap((event) async {
    final List<DocumentReference<Map<String, dynamic>>> chatRooms =
        event.get("chatRooms").cast<DocumentReference<Map<String, dynamic>>>();

    final chatRoomModels = chatRooms.map((chatRoomRef) async {
      final chatRoom = (await chatRoomRef.get());
      final UserProfileModel currentUser = UserProfileModel.fromJson(
          await getRefData(chatRoom, "currentUserRef"));
      final UserProfileModel otherUser =
          UserProfileModel.fromJson(await getRefData(chatRoom, "otherUserRef"));
      final Map<String, dynamic>? lastMessage =
          await getRefData(chatRoom, "lastMessageRef");
      final int? updatedAt = await lastMessage?['createdAt'];
      final String? text = await lastMessage?['text'];

      return ChatRoomModel(
        id: chatRoom.id,
        currentUser: currentUser,
        otherUser: otherUser,
        lastMessage: text,
        updatedAt: updatedAt,
      );
    });

    return await Future.wait(chatRoomModels);
  });

  return user;

  // final List<DocumentReference<Map<String, dynamic>>> chatRooms =
  //     user.get("chatRooms").cast<DocumentReference<Map<String, dynamic>>>();

  // yield await Future.wait(chatRoomModels);
});

Future<dynamic> getRefData(
    DocumentSnapshot<Map<String, dynamic>> document, String ref,
    [String? field]) async {
  try {
    final documentSnapshot =
        (await (document.get(ref) as DocumentReference<Map<String, dynamic>>)
            .get());

    if (field != null) {
      return documentSnapshot.get(field).data();
    }

    return documentSnapshot.data();
  } catch (e) {
    print(e);

    return null;
  }
}
