import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/colors.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';

class OTPScreen extends ConsumerWidget {
  final String otp;
  const OTPScreen({Key? key, required this.otp}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Verifying your number'),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text('We have sent an SMS with a code',
                textAlign: TextAlign.center),
            SizedBox(
              width: size.width * 0.5,
              child: TextField(
                inputFormatters: [
                  LengthLimitingTextInputFormatter(6),
                ],
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: "- - - - - -",
                  hintStyle: TextStyle(fontSize: 30),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value.length == 6) {
                    verifyOtp(ref, context, value.trim());
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void verifyOtp(WidgetRef ref, BuildContext context, String userEnteredOtp) {
    ref.read(authControllerProvider).verifyOTP(
          context,
          otp: otp,
          userEnteredOtp: userEnteredOtp,
        );
  }
}
