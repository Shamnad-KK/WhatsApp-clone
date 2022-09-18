import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_ui/colors.dart';
import 'package:whatsapp_ui/common/widgets/loader_widget.dart';
import 'package:whatsapp_ui/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_ui/models/chat_contact_model.dart';
import 'package:whatsapp_ui/routes/route_names.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: StreamBuilder<List<ChatContactModel>>(
          stream: ref.watch(chatControllerProvider).getChatContacts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoaderWidget();
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final chatContactData = snapshot.data![index];
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, RouteName.chatScreen,
                            arguments: {
                              "name": chatContactData.name,
                              "uid": chatContactData.contactId
                            });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ListTile(
                          title: Text(
                            chatContactData.name,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text(
                              chatContactData.lastMessage,
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.white),
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              chatContactData.profilePic,
                            ),
                            radius: 30,
                          ),
                          trailing: Text(
                            DateFormat.Hm().format(chatContactData.timeSent),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(color: dividerColor, indent: 85),
                  ],
                );
              },
            );
          }),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:whatsapp_ui/colors.dart';
// import 'package:whatsapp_ui/info.dart';
// import 'package:whatsapp_ui/features/chat/screens/mobile_chat_screen.dart';

// class ContactsList extends StatelessWidget {
//   const ContactsList({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 10.0),
//       child: ListView.builder(
//         shrinkWrap: true,
//         itemCount: info.length,
//         itemBuilder: (context, index) {
//           return Column(
//             children: [
//               InkWell(
//                 onTap: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) => const MobileChatScreen(
//                         name: 'SKK',
//                         uid: 'abc',
//                       ),
//                     ),
//                   );
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.only(bottom: 8.0),
//                   child: ListTile(
//                     title: Text(
//                       info[index]['name'].toString(),
//                       style: const TextStyle(
//                         fontSize: 18,
//                       ),
//                     ),
//                     subtitle: Padding(
//                       padding: const EdgeInsets.only(top: 6.0),
//                       child: Text(
//                         info[index]['message'].toString(),
//                         style: const TextStyle(fontSize: 15),
//                       ),
//                     ),
//                     leading: CircleAvatar(
//                       backgroundImage: NetworkImage(
//                         info[index]['profilePic'].toString(),
//                       ),
//                       radius: 30,
//                     ),
//                     trailing: Text(
//                       info[index]['time'].toString(),
//                       style: const TextStyle(
//                         color: Colors.grey,
//                         fontSize: 13,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const Divider(color: dividerColor, indent: 85),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
