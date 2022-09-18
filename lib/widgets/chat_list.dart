import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_ui/common/widgets/loader_widget.dart';
import 'package:whatsapp_ui/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_ui/models/message_model.dart';
import 'package:whatsapp_ui/widgets/my_message_card.dart';
import 'package:whatsapp_ui/widgets/sender_message_card.dart';

class ChatList extends ConsumerStatefulWidget {
  const ChatList({
    Key? key,
    required this.recieverUserId,
  }) : super(key: key);
  final String recieverUserId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController _messageScrollController = ScrollController();
  @override
  void dispose() {
    super.dispose();
    _messageScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MessageModel>>(
        stream:
            ref.read(chatControllerProvider).chatStream(widget.recieverUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoaderWidget();
          }
          SchedulerBinding.instance.addPostFrameCallback((_) {
            _messageScrollController
                .jumpTo(_messageScrollController.position.maxScrollExtent);
          });
          return ListView.builder(
            reverse: false,
            controller: _messageScrollController,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final messageData = snapshot.data![index];
              final timeSent = DateFormat.Hm().format(messageData.timeSent);
              if (messageData.senderId ==
                  FirebaseAuth.instance.currentUser?.uid) {
                return MyMessageCard(
                  message: messageData.text,
                  date: timeSent,
                );
              }
              return SenderMessageCard(
                message: messageData.text,
                date: timeSent,
              );
            },
          );
        });
  }
}
