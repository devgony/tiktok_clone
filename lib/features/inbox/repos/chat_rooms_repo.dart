import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatRoomsRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future getChatRooms() async {
    final a = _db.collection("chat_rooms").snapshots().map((event) => event.docs
        .map(
          (doc) => doc.data()["texts"],
        )
        .toList());
  }
}

final chatRoomsRepo = Provider(
  (ref) => ChatRoomsRepo(),
);
