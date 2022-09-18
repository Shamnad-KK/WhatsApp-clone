import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/features/auth/repositiory/auth_repository.dart';
import 'package:whatsapp_ui/models/user_model.dart';

final authControllerProvider = Provider(
  (ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    return AuthController(authRepository: authRepository, ref: ref);
  },
);

final userDataAuthProvider = FutureProvider((ref) {
  final authcontroller = ref.watch(authControllerProvider);
  return authcontroller.getUserData();
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;

  AuthController({
    required this.authRepository,
    required this.ref,
  });

  Future<UserModel?> getUserData() async {
    UserModel? user = await authRepository.getCurrentUserData();
    return user;
  }

  void signInWithPhone(BuildContext context, {required String phoneNumber}) {
    authRepository.signInWithPhone(context, phoneNumber: phoneNumber);
  }

  void verifyOTP(BuildContext context,
      {required String otp, required String userEnteredOtp}) {
    authRepository.verifyOTP(
      context,
      otp: otp,
      userEnteredOtp: userEnteredOtp,
    );
  }

  void saveUserDataToFirebase(BuildContext context,
      {required String name, required File? profilePic}) async {
    authRepository.saveUserDataToFirestore(
      name: name,
      profilePic: profilePic,
      ref: ref,
      context: context,
    );
  }

  Stream<UserModel> userDataById(String userId) {
    return authRepository.userData(userId);
  }
}
