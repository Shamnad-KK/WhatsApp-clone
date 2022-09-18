import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/colors.dart';
import 'package:whatsapp_ui/features/chat/controller/chat_controller.dart';

class BottomChatFieldWidget extends ConsumerStatefulWidget {
  const BottomChatFieldWidget({
    Key? key,
    required this.receiverUserId,
  }) : super(key: key);
  final String receiverUserId;
  @override
  ConsumerState<BottomChatFieldWidget> createState() =>
      _BottomChatFieldWidgetState();
}

class _BottomChatFieldWidgetState extends ConsumerState<BottomChatFieldWidget> {
  bool isShowSendButton = false;
  final TextEditingController _messageController = TextEditingController();

  void sendTextMessage() async {
    if (isShowSendButton) {
      ref.read(chatControllerProvider).sentTextMessage(
            context,
            _messageController.text.trim(),
            widget.receiverUserId,
          );
      setState(() {
        _messageController.text = '';
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _messageController,
            onChanged: (value) {
              setState(() {
                if (value.isNotEmpty) {
                  isShowSendButton = true;
                } else {
                  setState(() {
                    isShowSendButton = false;
                  });
                }
              });
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: mobileChatBoxColor,
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.emoji_emotions),
                        color: Colors.grey,
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.gif),
                        color: Colors.grey,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
              suffixIcon: SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.camera_alt),
                      color: Colors.grey,
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.attach_file),
                      color: Colors.grey,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              hintText: 'Type a message!',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              contentPadding: const EdgeInsets.all(10),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            bottom: 8.0,
            right: 2,
            left: 2,
          ),
          child: CircleAvatar(
            radius: 25,
            backgroundColor: const Color(0xFF128C7E),
            child: GestureDetector(
              onTap: sendTextMessage,
              child: Icon(
                isShowSendButton ? Icons.send : Icons.mic,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}
