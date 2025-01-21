import 'dart:io';

import 'package:data_base_project/GlobalWidgets/AnimationNavigation.dart';
import 'package:data_base_project/MainApplication/LoginSignUp/LoginPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GlobalAppBar extends StatelessWidget {
  final File? image;
  final String username;
  final bool shouldPop;

  const GlobalAppBar({
    required this.image,
    required this.username,
    required this.shouldPop,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF484848),
      leadingWidth: MediaQuery.of(context).size.width * 0.5,
      toolbarHeight: 75,
      leading: Row(
        children: [
          const SizedBox(width: 8),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: (image == null)
                    ? const AssetImage("assets/images/defaultProfile.png")
                    : FileImage(image!) as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 18),
          Text(
            username,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Colors.white),
          ),
        ],
      ),
      actions: [
        IconButton(
            onPressed: shouldPop
                ? () {
                    Navigator.pop(context);
                  }
                : () {
                    AnimationNavigation.navigatePopAllReplace(
                        const LoginPage(), context);
                  },
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.white,
              size: 30,
            )),
        const SizedBox(
          width: 20,
        ),
      ],
    );
  }
}
