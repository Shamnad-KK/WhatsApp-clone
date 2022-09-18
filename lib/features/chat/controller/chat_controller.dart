import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_ui/features/chat/repository/chat_repository.dart';
import 'package:whatsapp_ui/models/chat_contact_model.dart';
import 'package:whatsapp_ui/models/message_model.dart';

final chatControllerProvider = Provider(
  (ref) {
    final chatRepository = ref.watch(chatRepositoryProvider);
    return ChatController(chatRepository: chatRepository, ref: ref);
  },
);

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  void sentTextMessage(
      BuildContext context, String text, String receiverUserId) {
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendTextMessage(
            context,
            text: text,
            receiverUserId: receiverUserId,
            senderUser: value!,
          ),
        );
  }

  Stream<List<ChatContactModel>> getChatContacts() {
    return chatRepository.getChatContactList();
  }

  Stream<List<MessageModel>> chatStream(String recieverUserId) {
    return chatRepository.getChatStream(recieverUserId);
  }
}
