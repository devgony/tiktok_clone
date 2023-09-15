import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';

import '../../users/view_models/users_view_model.dart';
import '../../users/views/widgets/avatar.dart';
import '../view_models/chat_rooms_view_model.dart';

class SelectChatPartnerScreen extends ConsumerStatefulWidget {
  const SelectChatPartnerScreen({Key? key}) : super(key: key);

  @override
  _SelectChatPartnerScreenState createState() =>
      _SelectChatPartnerScreenState();

  static const String routeName = "select_chat_partner";
  static const String routeURL = "/select_chat_partner";
}

class _SelectChatPartnerScreenState
    extends ConsumerState<SelectChatPartnerScreen> {
  List<UserProfileModel> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final a = await ref.read(usersProvider.notifier).findProfiles();
    setState(() {
      _users = a;
    });
  }

  void openChat(UserProfileModel user) async {
    final id = await ref
        .read(chatRoomsProvider(null).notifier)
        .createChatRoom(user.uid);
    context.go('/chats/$id');
    // .pushNamed(ChatDetailScreen.routeName, arguments: user);
    // context.pushNamed(
    //   'chatDetail',
    //   arguments: user,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Select Chat Partner'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )),
      body: _users.isNotEmpty
          ? ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.bio),
                  leading: Avatar(
                    name: user.name,
                    uid: user.uid,
                    hasAvatar: user.hasAvatar,
                  ),
                  onTap: () {
                    openChat(user);
                  },
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
