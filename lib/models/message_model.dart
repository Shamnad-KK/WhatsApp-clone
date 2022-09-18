import 'package:whatsapp_ui/common/enums/message_enum.dart';

class MessageModel {
  final String senderId;
  final String recieverId;
  final String text;
  final MessageEnum messageType;
  final DateTime timeSent;
  final String messageId;
  final bool isSeen;

  MessageModel({
    required this.senderId,
    required this.recieverId,
    required this.text,
    required this.messageType,
    required this.timeSent,
    required this.messageId,
    required this.isSeen,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
        senderId: map["senderId"],
        recieverId: map["recieverId"],
        text: map["text"],
        messageType: (map["messageType"] as String).toEnum(),
        timeSent: DateTime.fromMillisecondsSinceEpoch(map["timeSent"]),
        messageId: map["messageId"],
        isSeen: map["isSeen"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "senderId": senderId,
      "recieverId": recieverId,
      "text": text,
      "messageType": messageType.type,
      "timeSent": timeSent.millisecondsSinceEpoch,
      "messageId": messageId,
      "isSeen": isSeen,
    };
  }
}
