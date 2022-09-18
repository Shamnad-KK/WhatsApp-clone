import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/repository/common_firebase_storage_repository.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/models/user_model.dart';
import 'package:whatsapp_ui/routes/route_names.dart';
import 'package:whatsapp_ui/screens/mobile_layout_screen.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({
    required this.auth,
    required this.firestore,
  });

  Future<UserModel?> getCurrentUserData() async {
    final userData =
        await firestore.collection("users").doc(auth.currentUser?.uid).get();

    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  Future<void> signInWithPhone(BuildContext context,
      {required String phoneNumber}) async {
    await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          showSnackBar(context: context, content: e.message!);
        },
        codeSent: (String otp, int? resendToken) async {
          Navigator.pushNamed(context, RouteName.otpScreen, arguments: otp);
        },
        codeAutoRetrievalTimeout: (String otp) {});
    try {} on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  Future<void> verifyOTP(
    BuildContext context, {
    required String otp,
    required String userEnteredOtp,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: otp, smsCode: userEnteredOtp);
      await auth.signInWithCredential(credential);
      showSnackBar(context: context, content: "Logged in successfully");
      Navigator.pushNamedAndRemoveUntil(
          context, RouteName.userInfoScreen, (route) => false);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void saveUserDataToFirestore(
      {required String name,
      required File? profilePic,
      required ProviderRef ref,
      required BuildContext context}) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl =
          "https://www.pngall.com/wp-content/uploads/5/Profile-PNG-File.png";

      if (profilePic != null) {
        photoUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFiletoFirebase(ref: 'profilePic/$uid', file: profilePic);

        final user = UserModel(
          name: name,
          uid: uid,
          profilePic: photoUrl,
          isOnline: true,
          phoneNumber: auth.currentUser!.phoneNumber.toString(),
          groupId: [],
        );

        await firestore.collection("users").doc(uid).set(user.toMap());

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (ctx) => const MobileLayoutScreen()),
            (route) => false);
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Stream<UserModel> userData(String uid) {
    return firestore
        .collection("users")
        .doc(uid)
        .snapshots()
        .map((event) => UserModel.fromMap(event.data()!));
  }

  void setUserState({required bool isOnline}) async {
    await firestore.collection("users").doc(auth.currentUser!.uid).update({
      "isOnline": isOnline,
    });
  }
}
