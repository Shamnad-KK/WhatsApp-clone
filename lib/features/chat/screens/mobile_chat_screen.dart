import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/colors.dart';
import 'package:whatsapp_ui/common/widgets/loader_widget.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_ui/features/chat/widgets/bottom_chat_field_widget.dart';
import 'package:whatsapp_ui/models/user_model.dart';
import 'package:whatsapp_ui/widgets/chat_list.dart';

class MobileChatScreen extends ConsumerWidget {
  const MobileChatScreen({Key? key, required this.name, required this.uid})
      : super(key: key);
  final String name;
  final String uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: StreamBuilder<UserModel>(
            stream: ref.read(authControllerProvider).userDataById(uid),
            builder: (context, AsyncSnapshot<UserModel> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoaderWidget();
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                    ),
                    Text(
                      snapshot.data!.isOnline ? "online" : "offline",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                );
              }
            }),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          const Expanded(
            child: ChatList(),
          ),
          BottomChatFieldWidget(
            receiverUserId: uid,
          ),
        ],
      ),
    );
  }
}
