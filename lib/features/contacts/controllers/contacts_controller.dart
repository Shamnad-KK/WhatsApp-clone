import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/features/contacts/repository/contact_repository.dart';

final getContactsProvider = FutureProvider((ref) {
  final contactRepository = ref.watch(contactRepositoryProvider);
  return contactRepository.getContacts();
});

final selectContactControllerProvider = Provider((ref) {
  final contactRepository = ref.watch(contactRepositoryProvider);
  return ContactController(ref: ref, contactRepository: contactRepository);
});

class ContactController {
  final ProviderRef ref;
  final ContactRepository contactRepository;

  ContactController({
    required this.ref,
    required this.contactRepository,
  });

  void selectContact(BuildContext context, {required Contact selectedContact}) {
    contactRepository.selectContact(selectedContact, context);
  }
}
