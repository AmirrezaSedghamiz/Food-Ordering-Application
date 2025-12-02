import 'package:data_base_project/GlobalWidgets/AnimationNavigation.dart';
import 'package:data_base_project/GlobalWidgets/GlobalAppBar.dart';
import 'package:data_base_project/MainApplication/Admin/SubPages/EditCustomer.dart';
import 'package:data_base_project/MainApplication/Admin/EditManager.dart'
    as edit_manager;
import 'package:data_base_project/MainApplication/Admin/SubPages/EditRestaurant.dart';
import 'package:data_base_project/SourceDesign/Admin.dart';
import 'package:data_base_project/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  final Admin admin;

  const AdminDashboard({super.key, required this.admin});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: const Color(0xFF201F22),
          resizeToAvoidBottomInset: true,
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(75),
              child: GlobalAppBarForAdmin(
                  username: widget.admin.username, shouldPop: false)),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  AnimationNavigation.navigatePush(
                      EditCustomer(admin: widget.admin), context);
                },
                child: Assets.images.customerService.image(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 70 / 900),
              ),
              const SizedBox(
                height: 12,
              ),
              GestureDetector(
                onTap: () {
                  AnimationNavigation.navigatePush(
                      edit_manager.EditMyManager(admin: widget.admin), context);
                },
                child: Assets.images.managerService.image(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 70 / 900),
              ),
              const SizedBox(
                height: 12,
              ),
              GestureDetector(
                onTap: () {
                  AnimationNavigation.navigatePush(
                      EditRestaurant(admin: widget.admin), context);
                },
                child: Assets.images.restaurantService.image(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 70 / 900),
              ),
              const SizedBox(
                height: 12,
              ),
              GestureDetector(
                onTap: () {},
                child: Assets.images.feedBackService.image(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 70 / 900),
              ),
            ],
          )),
    );
  }
}
