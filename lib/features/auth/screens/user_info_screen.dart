import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';

class UserInfoScreen extends ConsumerStatefulWidget {
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends ConsumerState<UserInfoScreen> {
  File? image;
  final TextEditingController nameController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void saveUserData() async {
    String name = nameController.text.trim();
    if (name.isNotEmpty) {
      ref.read(authControllerProvider).saveUserDataToFirebase(
            context,
            name: name,
            profilePic: image,
          );
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Stack(
                children: [
                  image == null
                      ? const CircleAvatar(
                          radius: 80,
                          backgroundImage: NetworkImage(
                              "https://www.pngall.com/wp-content/uploads/5/Profile-PNG-File.png"),
                        )
                      : CircleAvatar(
                          radius: 80,
                          backgroundImage: FileImage(image!),
                        ),
                  Positioned(
                    bottom: 2,
                    right: 20,
                    child: IconButton(
                      icon: const Icon(
                        Icons.add_a_photo,
                        size: 25,
                      ),
                      onPressed: () {
                        selectImage();
                      },
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    width: size.width * 0.85,
                    padding: const EdgeInsets.all(20),
                    child: TextField(
                      controller: nameController,
                      decoration:
                          const InputDecoration(hintText: "Enter your name"),
                    ),
                  ),
                  IconButton(
                    onPressed: saveUserData,
                    icon: const Icon(Icons.done),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
