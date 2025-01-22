import 'dart:io';
import 'dart:typed_data';

import 'package:data_base_project/GlobalWidgets/AnimationNavigation.dart';
import 'package:data_base_project/GlobalWidgets/GlobalAppBar.dart';
import 'package:data_base_project/GlobalWidgets/UintToFile.dart';
import 'package:data_base_project/MainApplication/Manager/Restaurant/NewRestaurant.dart';
import 'package:data_base_project/MainApplication/Manager/Restaurant/RestaurantItems.dart';
import 'package:data_base_project/SourceDesign/Category.dart';
import 'package:data_base_project/SourceDesign/DayHour.dart';
import 'package:data_base_project/SourceDesign/Manager.dart';
import 'package:data_base_project/SourceDesign/Restaurant.dart';
import 'package:data_base_project/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class ManagerDashboard extends StatelessWidget {
  final Manager manager;
  final int? restaurantId;

  ManagerDashboard({
    super.key,
    required this.manager,
    required this.restaurantId,
  });

  List<String> myDays = [
    'شنبه',
    'یکشنبه',
    'دوشنبه',
    'سه شنبه',
    'چهارشنبه',
    'پنجشنبه',
    'جمعه',
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File?>(
      future: uint8ListToFile(manager.image),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final imageFile = snapshot.data;

        return SafeArea(
          child: Scaffold(
              backgroundColor: const Color(0xFF201F22),
              resizeToAvoidBottomInset: true,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(75),
                child: Center(
                  child: GlobalAppBar(
                    image: imageFile,
                    username: manager.username,
                    shouldPop: false,
                  ),
                ),
              ),
              body: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {
                          Restaurant? restaurant =
                              await Restaurant.getRestaurantByManagerId(
                                  managerId: manager.managerid);
                          if (restaurant == null) {
                            AnimationNavigation.navigatePush(
                                NewRestaurant(
                                  startHour: const [],
                                  endHour: const [],
                                  day: const [],
                                  restaurantIdConfirm: restaurant?.restaurantId,
                                  restaurantPic: null,
                                  phoneNumber: null,
                                  image: imageFile,
                                  manager: manager,
                                  name: null,
                                  deliveryFee: null,
                                  maxDistance: null,
                                  address: null,
                                  timeControllers: null,
                                  location: null,
                                ),
                                context);
                          } else {
                            File restaurantImage =
                                (await uint8ListToFile(restaurant.image))!;
                            List<DayHour> dayHours = await DayHour.getDayHours(
                                    restaurantId: restaurant.restaurantId) ??
                                [];
                            List<WeekDay> weekDay = [
                              WeekDay.SUNDAY,
                              WeekDay.SATURADY,
                              WeekDay.MONDAY,
                              WeekDay.TUESDAY,
                              WeekDay.WEDNSDAY,
                              WeekDay.THURSDAY,
                              WeekDay.FRIDAY
                            ];
                            List<String?> days = [];
                            List<String?> startHours = [];
                            List<String?> endHours = [];
                            List<TextEditingController> controllers = [];
                            for (var i in dayHours) {
                              days.add(myDays[weekDay.indexOf(i.dayOfWeek)]);
                              startHours
                                  .add(convertPostgresTimeToHours(i.startHour));
                              endHours
                                  .add(convertPostgresTimeToHours(i.endHour));
                              controllers.add(TextEditingController(
                                  text:
                                      '${days.last} : ${startHours.last} - ${endHours.last}'));
                            }
                            AnimationNavigation.navigatePush(
                                NewRestaurant(
                                  day: days,
                                  startHour: startHours,
                                  endHour: endHours,
                                  restaurantIdConfirm: restaurant.restaurantId,
                                  restaurantPic: restaurantImage,
                                  phoneNumber: restaurant.phoneNumber,
                                  image: imageFile,
                                  manager: manager,
                                  name: restaurant.name,
                                  deliveryFee:
                                      restaurant.deliveryFee.toString(),
                                  maxDistance:
                                      restaurant.deliveryRadius.toString(),
                                  address: restaurant.address,
                                  timeControllers: controllers,
                                  location: restaurant.point,
                                ),
                                context);
                          }
                        },
                        child: Assets.images.managerRestaurant.image(
                            width:
                                MediaQuery.of(context).size.width * 160 / 412,
                            height:
                                MediaQuery.of(context).size.height * 120 / 900),
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      InkWell(
                        onTap: () async {
                          if (restaurantId == null) {
                            AnimationNavigation.navigatePush(
                                NewRestaurant(
                                  startHour: const [],
                                  endHour: const [],
                                  day: const [],
                                  restaurantIdConfirm: null,
                                  restaurantPic: null,
                                  phoneNumber: null,
                                  image: imageFile,
                                  manager: manager,
                                  name: null,
                                  deliveryFee: null,
                                  maxDistance: null,
                                  address: null,
                                  timeControllers: null,
                                  location: null,
                                ),
                                context);
                            return;
                          }
                          List<Category> categories =
                              await Category.getCategoriesByRestaurantId(
                                      restaurantId: restaurantId!,
                                      page: 1,
                                      pageSize: 5) ??
                                  [];
                          AnimationNavigation.navigatePush(
                              RestaurantItems(
                                  restaurantId: restaurantId!,
                                  image: imageFile,
                                  categories: categories,
                                  manager: manager),
                              context);
                        },
                        child: Assets.images.managerMenu.image(
                            width:
                                MediaQuery.of(context).size.width * 160 / 412,
                            height:
                                MediaQuery.of(context).size.height * 120 / 900),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Assets.images.managerOrders.image(
                            width:
                                MediaQuery.of(context).size.width * 160 / 412,
                            height:
                                MediaQuery.of(context).size.height * 120 / 900),
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      InkWell(
                        onTap: () {},
                        child: Assets.images.managerHistory.image(
                            width:
                                MediaQuery.of(context).size.width * 160 / 412,
                            height:
                                MediaQuery.of(context).size.height * 120 / 900),
                      ),
                    ],
                  )
                ],
              )),
        );
      },
    );
  }

  String convertPostgresTimeToHours(String timeStr) {
    int hour24 = int.parse(timeStr.split(':')[0]);
    String hour;
    String suffix;

    if (hour24 == 0) {
      hour = '24';
      suffix = 'شب';
    } else if (hour24 == 12) {
      hour = '12';
      suffix = 'ظهر';
    } else if (hour24 < 12) {
      hour = hour24.toString();
      suffix = 'صبح';
    } else if (hour24 < 16) {
      hour = (hour24).toString();
      suffix = 'ظهر';
    } else {
      hour = (hour24).toString();
      suffix = 'شب';
    }
    return '$hour $suffix';
  }
}
