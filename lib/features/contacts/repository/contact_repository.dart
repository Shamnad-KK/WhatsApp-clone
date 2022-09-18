import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/models/user_model.dart';
import 'package:whatsapp_ui/routes/route_names.dart';

final contactRepositoryProvider = Provider(
  (ref) => ContactRepository(
    firestore: FirebaseFirestore.instance,
  ),
);

class ContactRepository {
  final FirebaseFirestore firestore;

  ContactRepository({required this.firestore});

  Future<List<Contact>> getContacts() async {
    List<Contact> contactList = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contactList = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contactList;
  }

  void selectContact(Contact selectedContact, BuildContext context) async {
    try {
      final userCollection = await firestore.collection("users").get();
      bool isFound = false;
      for (final document in userCollection.docs) {
        final userData = UserModel.fromMap(document.data());
        log(selectedContact.phones[0].normalizedNumber);
        String selectedPhoneNumber =
            selectedContact.phones[0].normalizedNumber.replaceAll(' ', '');
        //selectedContact.phones[0].normalizedNumber
        if (selectedPhoneNumber == userData.phoneNumber) {
          isFound = true;
          Navigator.pushNamed(context, RouteName.chatScreen, arguments: {
            "name": userData.name,
            "uid": userData.uid,
          });
        }
        if (!isFound) {
          showSnackBar(
              context: context,
              content: "This number doesn't exist in this app");
        }
      }
    } catch (e) {
      showSnackBar(
        context: context,
        content: e.toString(),
      );
    }
  }
}
