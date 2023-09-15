import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/inbox/repos/chat_rooms_repo.dart';

import '../../authentication/repos/authentication_repo.dart';
import '../models/chat_room.dart';

class ChatRoomsViewModel extends FamilyAsyncNotifier<ChatRoomModel?, String?> {
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

  Future<ChatRoomModel> getChatRoom(String chatRoomId) async {
    final user = ref.read(authRepo).user;

    return await _repo.getChatRoom(user!.uid, chatRoomId);
  }

  @override
  FutureOr<ChatRoomModel?> build(String? arg) async {
    _repo = ref.read(chatRoomsRepo);

    if (arg == null) {
      return null;
    }

    return await getChatRoom(arg);
  }
}

final chatRoomsProvider =
    AsyncNotifierProviderFamily<ChatRoomsViewModel, ChatRoomModel?, String?>(
  () => ChatRoomsViewModel(),
);

final chatRoomsStreamProvider =
    StreamProvider.autoDispose<List<ChatRoomModel>>((ref) {
  // final repo = ref.read(chatRoomsRepo);
  final uid = ref.read(authRepo).user!.uid;
  final db = FirebaseFirestore.instance;

  return db
      .collection("users")
      .doc(uid)
      .collection("chatRooms")
      .orderBy("updatedAt", descending: true)
      .snapshots()
      .map((event) => event.docs.map((doc) {
            print(doc);
            print(doc.id);
            return ChatRoomModel.fromJson({"id": doc.id, ...doc.data()});
          }).toList());

  // final user = db.collection("users").doc(uid).snapshots().asyncMap((event) async {
  // final x = event.("chatRooms");

  // final List<DocumentReference<Map<String, dynamic>>> chatRooms =
  //     event.get("chatRooms").cast<DocumentReference<Map<String, dynamic>>>();

  // final chatRoomModels = chatRooms.map((chatRoomRef) async {
  //   final chatRoom = (await chatRoomRef.get());
  //   final UserProfileModel currentUser = UserProfileModel.fromJson(
  //       await getRefData(chatRoom, "currentUserRef"));
  //   final UserProfileModel otherUser =
  //       UserProfileModel.fromJson(await getRefData(chatRoom, "otherUserRef"));
  //   final Map<String, dynamic>? lastMessage =
  //       await getRefData(chatRoom, "lastMessageRef");
  //   final int? updatedAt = await lastMessage?['createdAt'];
  //   final String? text = await lastMessage?['text'];

  //   return ChatRoomModel(
  //     id: chatRoom.id,
  //     currentUser: currentUser,
  //     otherUser: otherUser,
  //     lastMessage: text,
  //     updatedAt: updatedAt,
  //   );
  // });

  // return await Future.wait(chatRoomModels);
  // });

  // return user;

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
