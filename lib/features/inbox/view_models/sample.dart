// final chatRoomStreamProvider =
//     StreamProvider.autoDispose.family<ChatRoomModel, String>((ref, chatRoomId) {
//   final db = FirebaseFirestore.instance;
//   final chatRoomRef = db.collection("chatRooms").doc(chatRoomId);

//   return chatRoomRef.snapshots().map((event) async {
//     final UserProfileModel currentUser =
//         UserProfileModel.fromJson(await getRefData(event, "currentUserRef"));
//     final UserProfileModel otherUser =
//         UserProfileModel.fromJson(await getRefData(event, "otherUserRef"));
//     final Map<String, dynamic>? lastMessage =
//         await getRefData(event, "lastMessageRef");
//     final int? updatedAt = await lastMessage?['createdAt'];
//     final String? text = await lastMessage?['text'];

//     return ChatRoomModel(
//       id: event.id,
//       currentUser: currentUser,
//       otherUser: otherUser,
//       lastMessage: text,
//       updatedAt: updatedAt,
//     );
//   });
// });

// class ChatRoomViewModel extends StateNotifier<AsyncValue<ChatRoomModel>> {
//   ChatRoomViewModel(this._read, String chatRoomId)
//       : super(const AsyncValue.loading()) {
//     _chatRoomId = chatRoomId;
//     _chatRoomStream = _read(chatRoomStreamProvider(chatRoomId));
//     _chatRoomStream.whenData((data) => state = AsyncValue.data(data));
//     _chatRoomStream.whenError(
//         (error, stackTrace) => state = AsyncValue.error(error, stackTrace));
//   }

//   final Reader _read;
//   late final String _chatRoomId;
//   late final Stream<ChatRoomModel> _chatRoomStream;

//   void sendMessage(String message) async {
//     // Send message to chat room
//   }

//   @override
//   void dispose() {
//     _chatRoomStream.drain();
//     super.dispose();
//   }
// }
