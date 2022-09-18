import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_ui/common/enums/message_enum.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/models/chat_contact_model.dart';
import 'package:whatsapp_ui/models/message_model.dart';
import 'package:whatsapp_ui/models/user_model.dart';

final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepository({
    required this.firestore,
    required this.auth,
  });

  void _saveDatatoContactSubCollection({
    required UserModel sendersUserData,
    required UserModel recieversUserData,
    required String text,
    required DateTime timeSent,
    required String recieversUserId,
  }) async {
    //users collection => recieverUserId => chats collection => currentUserId => set data
    final recieverChatContact = ChatContactModel(
        name: sendersUserData.name,
        profilePic: sendersUserData.profilePic,
        contactId: sendersUserData.uid,
        timeSent: timeSent,
        lastMessage: text);
    await firestore
        .collection("users")
        .doc(recieversUserId)
        .collection("chats")
        .doc(sendersUserData.uid)
        .set(recieverChatContact.toMap());

    //users collection =>  currentUserId => chats collection => recieverUserId => set data

    final senderChatContact = ChatContactModel(
        name: recieversUserData.name,
        profilePic: recieversUserData.profilePic,
        contactId: recieversUserData.uid,
        timeSent: timeSent,
        lastMessage: text);
    await firestore
        .collection("users")
        .doc(sendersUserData.uid)
        .collection("chats")
        .doc(recieversUserData.uid)
        .set(senderChatContact.toMap());
  }

  void _saveMessagetoMessageSubCollection({
    required String recieverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String senderUserNamme,
    required String recieverUsername,
    required MessageEnum messageType,
  }) async {
    final message = MessageModel(
        senderId: auth.currentUser!.uid,
        recieverId: recieverUserId,
        text: text,
        messageType: messageType,
        timeSent: timeSent,
        messageId: messageId,
        isSeen: false);

    //users collection => senderId => receiverId => messages collection => messageId => store message
    await firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("chats")
        .doc(recieverUserId)
        .collection("messages")
        .doc(messageId)
        .set(message.toMap());
    //users collection => receiverId => senderId => messages collection => messageId => store message

    await firestore
        .collection("users")
        .doc(recieverUserId)
        .collection("chats")
        .doc(auth.currentUser!.uid)
        .collection("messages")
        .doc(messageId)
        .set(message.toMap());
  }

  void sendTextMessage(
    BuildContext context, {
    required String text,
    required String receiverUserId,
    required UserModel senderUser,
  }) async {
    try {
      final messageId = const Uuid().v1();
      final timeSent = DateTime.now();
      UserModel recieverUserData;
      final userDataMap =
          await firestore.collection("users").doc(receiverUserId).get();
      recieverUserData = UserModel.fromMap(userDataMap.data()!);

      _saveDatatoContactSubCollection(
          sendersUserData: senderUser,
          recieversUserData: recieverUserData,
          text: text,
          timeSent: timeSent,
          recieversUserId: receiverUserId);

      _saveMessagetoMessageSubCollection(
          recieverUserId: receiverUserId,
          text: text,
          timeSent: timeSent,
          messageId: messageId,
          senderUserNamme: senderUser.name,
          recieverUsername: recieverUserData.name,
          messageType: MessageEnum.text);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
