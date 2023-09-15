import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/inbox/view_models/chat_rooms_view_model.dart';

import '../../authentication/repos/authentication_repo.dart';
import '../view_models/messages_view_model.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  static const String routeName = "chatDetail";
  static const String routeURL = ":chatId";

  final String chatId;

  const ChatDetailScreen({
    super.key,
    required this.chatId,
  });

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  bool _writing = false;
  // late final ChatRoomModel? _otherUserChatRoom;

  // @override
  // void initState() async {
  //   ref
  //       .read(chatRoomsProvider.notifier)
  //       .getChatRoom(widget.chatId)
  //       .then((chatRoom) {
  //     setState(() {
  //       _otherUserChatRoom = chatRoom;
  //     });
  //   });
  //   super.initState();
  // }

  void _onTextChanged(String value) {
    setState(() {
      _writing = value.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _onSendPress() {
    final text = _textEditingController.text;
    if (text == "") {
      return;
    }
    ref.read(messagesProvider(widget.chatId).notifier).sendMessage(text);

    _textEditingController.clear();
    setState(() {
      _writing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(messagesProvider(widget.chatId)).isLoading;
    return Scaffold(
      appBar: AppBar(
        // leadingWidth: 30,
        titleSpacing: 0,

        title: ref.read(chatRoomsProvider(widget.chatId)).when(
              error: (error, stackTrace) => const Text('Error'),
              loading: () => const Text('Loading...'),
              data: (chatRoom) {
                if (chatRoom == null) {
                  return const Text('Error');
                }

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  horizontalTitleGap: Sizes.size8,
                  leading: Stack(
                    children: [
                      CircleAvatar(
                        radius: Sizes.size24,
                        foregroundImage: NetworkImage(
                          "https://firebasestorage.googleapis.com/v0/b/tiktok-devgony.appspot.com/o/avatars%2F${chatRoom.otherUser.uid}?alt=media&haha=${DateTime.now().toString()}",
                        ),
                        child: Text(chatRoom.otherUser.name),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: Sizes.size18,
                          height: Sizes.size18,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: Sizes.size3,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  title: Text(
                    chatRoom.otherUser.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: const Text('Active now'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      FaIcon(
                        FontAwesomeIcons.flag,
                        color: Colors.black,
                        size: Sizes.size20,
                      ),
                      Gaps.h32,
                      FaIcon(
                        FontAwesomeIcons.ellipsis,
                        color: Colors.black,
                        size: Sizes.size20,
                      ),
                      Gaps.h16,
                    ],
                  ),
                );
              },
            ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            ref.watch(chatProvider2(widget.chatId)).when(
                  data: (data) {
                    return ListView.separated(
                      reverse: true,
                      padding: EdgeInsets.only(
                        top: Sizes.size20,
                        bottom: MediaQuery.of(context).padding.bottom +
                            Sizes.size96,
                        left: Sizes.size14,
                        right: Sizes.size14,
                      ),
                      itemBuilder: (context, index) {
                        final message = data[index];
                        final isMine =
                            message.userId == ref.watch(authRepo).user!.uid;
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: isMine
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(Sizes.size14),
                              decoration: BoxDecoration(
                                color: isMine
                                    ? Colors.blue
                                    : Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(
                                    Sizes.size20,
                                  ),
                                  topRight: const Radius.circular(
                                    Sizes.size20,
                                  ),
                                  bottomLeft: Radius.circular(
                                    isMine ? Sizes.size20 : Sizes.size5,
                                  ),
                                  bottomRight: Radius.circular(
                                    !isMine ? Sizes.size20 : Sizes.size5,
                                  ),
                                ),
                              ),
                              child: Text(
                                message.text,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: Sizes.size16,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) => Gaps.v10,
                      itemCount: data.length,
                    );
                  },
                  error: (error, stackTrace) => Center(
                    child: Text(
                      error.toString(),
                    ),
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            Positioned(
              bottom: 0,
              width: MediaQuery.of(context).size.width,
              child: BottomAppBar(
                height: Platform.isIOS ? 100 : 80,
                color: Colors.grey.shade50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      // horizontal: Sizes.size8,
                      // vertical: Sizes.size2,
                      ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textEditingController,
                          onChanged: _onTextChanged,
                          onSubmitted: (_) => _onSendPress,
                          textInputAction: TextInputAction.send,
                          expands: true,
                          minLines: null,
                          maxLines: null,
                          decoration: InputDecoration(
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                Sizes.size12,
                              ),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: Sizes.size12,
                            ),
                            hintText: 'Send a message...',
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                            ),
                            fillColor: Colors.white,
                            suffixIcon: const Icon(
                              Icons.insert_emoticon,
                              size: Sizes.size32,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Gaps.h20,
                      Container(
                        width: Sizes.size40,
                        height: Sizes.size40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade300,
                        ),
                        child: GestureDetector(
                          onTap: _onSendPress,
                          child: Center(
                            child: FaIcon(
                              isLoading
                                  ? null
                                  : FontAwesomeIcons.solidPaperPlane,
                              color: _writing
                                  ? Theme.of(context).primaryColor
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
