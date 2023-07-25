import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/inbox/repos/chat_rooms_repo.dart';

import '../../authentication/repos/authentication_repo.dart';

class ChatRoomsViewModel extends AsyncNotifier<void> {
  late final ChatRoomsRepo _repo;
  late final String chatRoomId;
  // final List<ChatRoomModel> _list = [];

  // Future<List<ChatRoomModel>> _fetchChatRooms() async {
  //   final user = ref.read(authRepo).user;

  //   return _repo.fetchChatRooms(user!.uid);
  // }

  Future createChatRoom(String otherUid) async {
    final user = ref.read(authRepo).user;
    state = const AsyncValue.loading();
    final id = await _repo.createChatRoom(user!.uid, otherUid);

    state = AsyncValue.data(chatRoomId = id);
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
