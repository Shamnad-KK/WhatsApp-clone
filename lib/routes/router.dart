import 'package:flutter/material.dart';
import 'package:whatsapp_ui/common/widgets/error_widget.dart';
import 'package:whatsapp_ui/features/auth/screens/login_screen.dart';
import 'package:whatsapp_ui/features/auth/screens/otp_screen.dart';
import 'package:whatsapp_ui/features/auth/screens/user_info_screen.dart';
import 'package:whatsapp_ui/features/contacts/screens/contacts_screen.dart';
import 'package:whatsapp_ui/routes/route_names.dart';
import 'package:whatsapp_ui/features/chat/screens/mobile_chat_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case RouteName.loginScreen:
      return MaterialPageRoute(builder: (context) => const LoginScreen());
    case RouteName.otpScreen:
      final otp = settings.arguments as String;
      return MaterialPageRoute(
          builder: (context) => OTPScreen(
                otp: otp,
              ));
    case RouteName.userInfoScreen:
      return MaterialPageRoute(builder: (context) => const UserInfoScreen());
    case RouteName.contactScreen:
      return MaterialPageRoute(builder: (context) => const ContactScreen());
    case RouteName.chatScreen:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments["name"];
      final uid = arguments["uid"];
      return MaterialPageRoute(
          builder: (context) => MobileChatScreen(
                name: name,
                uid: uid,
              ));

    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: SafeArea(
            child: ErrorTextWidget(text: "This page doesn't exist"),
          ),
        ),
      );
  }
}
