import 'dart:io';
import 'dart:typed_data';

import 'package:data_base_project/GlobalWidgets/AnimationNavigation.dart';
import 'package:data_base_project/MainApplication/Customer/Profile/Profile.dart';
import 'package:data_base_project/MainApplication/LoginSignUp/LoginPage.dart';
import 'package:data_base_project/MainApplication/Manager/Profile/ProfileManager.dart';
import 'package:data_base_project/SourceDesign/Admin.dart';
import 'package:data_base_project/SourceDesign/Customer.dart';
import 'package:data_base_project/SourceDesign/Manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GlobalAppBar extends StatelessWidget {
  final File? image;
  final String username;
  final bool shouldPop;
  final Customer? customer;
  final Manager? manager;
  final bool isManager;

  const GlobalAppBar({
    required this.image,
    required this.username,
    required this.shouldPop,
    required this.customer,
    required this.manager,
    required this.isManager,
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
          GestureDetector(
            onTap: () {
              AnimationNavigation.navigatePush(
                  isManager
                      ? ProfileManager(manager: manager!)
                      : Profile(customer: customer!),
                  context);
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: (image == null)
                      ? const AssetImage("assets/images/defaultProfile.png")
                      : FileImage(image!) as ImageProvider,
                  fit: BoxFit.cover,
                ),
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

class GlobalAppBarForAdmin extends StatelessWidget {
  final Uint8List? image;
  final String username;
  final bool shouldPop;

  const GlobalAppBarForAdmin({
    super.key,
    this.image,
    required this.username,
    required this.shouldPop,
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
              shape: BoxShape.circle,
              image: DecorationImage(
                image: (image == null)
                    ? const AssetImage("assets/images/defaultProfile.png")
                    : MemoryImage(image!) as ImageProvider,
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
