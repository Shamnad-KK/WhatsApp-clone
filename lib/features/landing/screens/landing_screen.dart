import 'package:flutter/material.dart';
import 'package:whatsapp_ui/colors.dart';
import 'package:whatsapp_ui/common/widgets/custom_button_widget.dart';
import 'package:whatsapp_ui/routes/route_names.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const Text(
              'Welcome to Whatsapp',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 33,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: size.height / 9),
            Image.asset(
              "assets/bg.png",
              height: 340,
              width: 340,
              color: tabColor,
            ),
            SizedBox(height: size.height / 9),
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Read our all Privacy Policy. Tap "Agree and continue" to accept the Terms and Conditions',
                textAlign: TextAlign.center,
                style: TextStyle(color: greyColor),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: size.width * 0.75,
              child: CustomButtonWidget(
                text: "AGREE AND CONTINUE",
                onPressed: () {
                  gotoLogin(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void gotoLogin(BuildContext context) {
    Navigator.pushNamed(context, RouteName.loginScreen);
  }
}
