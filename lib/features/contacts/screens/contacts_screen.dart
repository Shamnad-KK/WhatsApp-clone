import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/widgets/error_widget.dart';
import 'package:whatsapp_ui/common/widgets/loader_widget.dart';
import 'package:whatsapp_ui/features/contacts/controllers/contacts_controller.dart';

class ContactScreen extends ConsumerWidget {
  const ContactScreen({Key? key}) : super(key: key);
  void selectContact(
      WidgetRef ref, Contact selectedContact, BuildContext context) {
    ref
        .read(selectContactControllerProvider)
        .selectContact(context, selectedContact: selectedContact);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select contact'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: ref.watch(getContactsProvider).when(
          data: (contactList) {
            return ListView.builder(
              itemCount: contactList.length,
              itemBuilder: (BuildContext context, int index) {
                final contact = contactList[index];
                return InkWell(
                  onTap: () {
                    selectContact(ref, contact, context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      leading: contact.photo == null
                          ? null
                          : CircleAvatar(
                              radius: 30,
                              backgroundImage: MemoryImage(
                                contact.photo!,
                              ),
                            ),
                      title: Text(
                        contact.displayName,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                );
              },
            );
          },
          error: (error, stackTrace) {
            return ErrorTextWidget(text: error.toString());
          },
          loading: () => const LoaderWidget()),
    );
  }
}
