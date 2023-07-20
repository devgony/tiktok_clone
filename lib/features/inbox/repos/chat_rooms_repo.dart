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

          // .orderBy("createdAt", descending: true)
          .snapshots()
          .asyncMap((event) async {
        final chatRooms = <ChatRoomModel>[];
        for (final doc in event.docs) {
          final chatRoomData = doc.data();
          final chatRoomRef = chatRoomData['ref'] as DocumentReference;
          final chatRoomSnapshot = chatRoomRef.get();
          final chatRoomData2 =
              (await chatRoomSnapshot).data() as Map<String, dynamic>;
          final chatRoom = ChatRoomModel.fromJson(chatRoomData2);
          chatRooms.add(chatRoom);
        }
        print(chatRooms);

        return chatRooms;
      });

  Future createChatRoom(String uid, String otherUid) async {
    final chatRoom = ChatRoomModel(
      personA: uid,
      personB: otherUid,
      lastMessage: "",
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );

    await _db
        .collection("users")
        .doc(uid)
        .collection("chat_rooms")
        .doc(otherUid)
        .set(chatRoom.toJson());

    await _db
        .collection("users")
        .doc(otherUid)
        .collection("chat_rooms")
        .doc(uid)
        .set(chatRoom.toJson());
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
