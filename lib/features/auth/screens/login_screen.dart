import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/colors.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/common/widgets/custom_button_widget.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  Country? _country;

  void pickCountry() {
    showCountryPicker(
      context: context,
      onSelect: (Country country) {
        setState(() {
          _country = country;
        });
      },
    );
  }

  void sendPhoneNumber() {
    String phone = phoneController.text.trim();
    if (phone.isNotEmpty && _country != null) {
      ref.read(authControllerProvider).signInWithPhone(context,
          phoneNumber: "+${_country!.phoneCode}$phone");
    } else {
      showSnackBar(context: context, content: "Fill out all the fields");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Enter your phone number'),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Whatsapp will need to verify your phone number"),
              const SizedBox(height: 10),
              TextButton(
                onPressed: pickCountry,
                child: const Text('Pick country'),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  if (_country != null) Text("+${_country!.phoneCode}"),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: size.width * 0.7,
                    child: TextField(
                      controller: phoneController,
                      decoration:
                          const InputDecoration(hintText: "phone number"),
                      keyboardType: TextInputType.number,
                    ),
                  )
                ],
              ),
              SizedBox(height: size.height * 0.6),
              SizedBox(
                width: 90,
                child: CustomButtonWidget(
                  text: "NEXT",
                  onPressed: () {
                    sendPhoneNumber();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
