import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/inbox/models/chat_room.dart';
import 'package:tiktok_clone/features/inbox/views/select_chat_partner_screen.dart';
import '../view_models/chat_rooms_view_model.dart';
import 'chat_detail_screen.dart';

class ChatsScreen extends ConsumerStatefulWidget {
  static const String routeName = "chats";
  static const String routeURL = "/chats";
  const ChatsScreen({super.key});

  @override
  ConsumerState<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends ConsumerState<ChatsScreen> {
  final GlobalKey<AnimatedListState> _key = GlobalKey<AnimatedListState>();

  final List<int> _items = [];

  // final List<ChatRoomModel> _chatRooms = [];

  final Duration _duration = const Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
  }

  void _addItem() {
    // if (_key.currentState != null) {
    //   _key.currentState!.insertItem(
    //     _items.length,
    //     duration: _duration,
    //   );
    //   _items.add(_items.length);
    // }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SelectChatPartnerScreen(),
      ),
    );
  }

  void _deleteItem(int index) {
    if (_key.currentState != null) {
      _key.currentState!.removeItem(
        index,
        (context, animation) => SizeTransition(
          sizeFactor: animation,
          child: Container(
            color: Colors.red,
            // child: _makeTile(index),
          ),
        ),
        duration: _duration,
      );
      _items.removeAt(index);
    }
  }

  void _onChatTap(int index) {
    context.pushNamed(
      ChatDetailScreen.routeName,
      params: {"chatId": "$index"},
    );
  }

  Widget _makeTile(ChatRoomModel chatRoom) {
    return ListTile(
      // onLongPress: () => _deleteItem(index),
      // onTap: () => _onChatTap(index),
      leading: CircleAvatar(
        // TODO: should merge with Avatar widget
        radius: 30,
        foregroundImage: NetworkImage(
          "https://firebasestorage.googleapis.com/v0/b/tiktok-devgony.appspot.com/o/avatars%2F${chatRoom.otherUser.uid}?alt=media&haha=${DateTime.now().toString()}",
        ),
        child: Text(chatRoom.otherUser.name),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            chatRoom.otherUser.name,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Text(
            DateFormat('a hh:mm').format(
                DateTime.fromMillisecondsSinceEpoch(chatRoom.updatedAt * 1000)),
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: Sizes.size12,
            ),
          ),
        ],
      ),
      subtitle: Text(chatRoom.lastMessage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text('Direct messages'),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const FaIcon(FontAwesomeIcons.plus),
          ),
        ],
      ),
      body: ref.watch(chatRoomsStreamProvider).when(
        data: (data) {
          return AnimatedList(
            // key: _key,
            padding: const EdgeInsets.symmetric(
              vertical: Sizes.size10,
            ),
            initialItemCount: data.length,
            itemBuilder: (context, index, animation) {
              final chatRoom = data[index];

              return FadeTransition(
                key: Key('$index'),
                opacity: animation,
                child: SizeTransition(
                    sizeFactor: animation, child: _makeTile(chatRoom)),
              );
            },
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Text(error.toString()),
          );
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
