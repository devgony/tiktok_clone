import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/inbox/models/chat_room.dart';
import 'package:tiktok_clone/features/inbox/repos/chat_rooms_repo.dart';

class ChatRoomsViewModel extends AsyncNotifier<void> {
  late final ChatRoomsRepo _repo;

  @override
  FutureOr<void> build() {
    _repo = ref.read(chatRoomsRepo);
  }

  Future getChatRooms() async {
    return _repo.getChatRooms();
  }
}

final chatRoomsProvider = AsyncNotifierProvider<ChatRoomsViewModel, void>(
  () => ChatRoomsViewModel(),
);

final chatProvider = StreamProvider.autoDispose<List<ChatRoomModel>>((ref) {
  final db = FirebaseFirestore.instance;

  return db
      .collection("chat_rooms")
      .orderBy("createdAt")
      .snapshots()
      .map((event) => event.docs
          .map(
            (doc) => ChatRoomModel.fromJson(
              doc.data(),
            ),
          )
          .toList());
});
