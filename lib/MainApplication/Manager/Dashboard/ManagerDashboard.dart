import 'dart:io';
import 'package:flutter/material.dart';
import 'package:data_base_project/GlobalWidgets/AnimationNavigation.dart';
import 'package:data_base_project/GlobalWidgets/GlobalAppBar.dart';
import 'package:data_base_project/GlobalWidgets/UintToFile.dart';
import 'package:data_base_project/MainApplication/Manager/Orders/orderForManager.dart';
import 'package:data_base_project/MainApplication/Manager/Orders/ordersHistoryForManager.dart';
import 'package:data_base_project/MainApplication/Manager/Restaurant/NewRestaurant.dart';
import 'package:data_base_project/MainApplication/Manager/Restaurant/RestaurantItems.dart';
import 'package:data_base_project/SourceDesign/Category.dart';
import 'package:data_base_project/SourceDesign/DayHour.dart';
import 'package:data_base_project/SourceDesign/Manager.dart';
import 'package:data_base_project/SourceDesign/Restaurant.dart';
import 'package:data_base_project/gen/assets.gen.dart';

class ManagerDashboard extends StatefulWidget {
  final Manager manager;
  final int? restaurantId;

  const ManagerDashboard({
    super.key,
    required this.manager,
    required this.restaurantId,
  });

  @override
  _ManagerDashboardState createState() => _ManagerDashboardState();
}

class _ManagerDashboardState extends State<ManagerDashboard> {
  bool isLoading = false;
  File? managerImage;
  List<String> myDays = [
    'شنبه',
    'یکشنبه',
    'دوشنبه',
    'سه شنبه',
    'چهارشنبه',
    'پنجشنبه',
    'جمعه'
  ];

  @override
  void initState() {
    super.initState();
    _initializeManagerImage();
  }

  Future<void> _initializeManagerImage() async {
    managerImage = await uint8ListToFile(widget.manager.image);
    setState(() {});
  }

  Future<void> _navigateToRestaurant(BuildContext context) async {
    setState(() => isLoading = true);

    Restaurant? restaurant = await Restaurant.getRestaurantByManagerId(
        managerId: widget.manager.managerid);

    if (restaurant == null) {
      _navigateToNewRestaurant(context);
    } else {
      File restaurantImage = (await uint8ListToFile(restaurant.image))!;
      List<DayHour> dayHours =
          await DayHour.getDayHours(restaurantId: restaurant.restaurantId) ??
              [];
      dayHours.sort((a, b) => a.dayOfWeek.index.compareTo(b.dayOfWeek.index));

      List<String?> days = [], startHours = [], endHours = [];
      List<TextEditingController> controllers = [];

      for (var i in dayHours) {
        days.add(myDays[i.dayOfWeek.index]);
        startHours.add(convertPostgresTimeToHours(i.startHour));
        endHours.add(convertPostgresTimeToHours(i.endHour));
        controllers.add(TextEditingController(
            text: '${days.last} : ${startHours.last} - ${endHours.last}'));
      }

      AnimationNavigation.navigatePush(
        NewRestaurant(
          minPurchase: restaurant.minimumPurchase.toString(),
          day: days,
          startHour: startHours,
          endHour: endHours,
          restaurantIdConfirm: restaurant.restaurantId,
          restaurantPic: restaurantImage,
          phoneNumber: restaurant.phoneNumber,
          image: managerImage,
          manager: widget.manager,
          name: restaurant.name,
          deliveryFee: restaurant.deliveryFee.toString(),
          maxDistance: restaurant.deliveryRadius.toString(),
          address: restaurant.address,
          timeControllers: controllers,
          location: restaurant.point,
        ),
        context,
      );
    }
    setState(() => isLoading = false);
  }

  void _navigateToNewRestaurant(BuildContext context) {
    AnimationNavigation.navigatePush(
      NewRestaurant(
        startHour: [],
        endHour: [],
        day: [],
        minPurchase: null,
        restaurantIdConfirm: null,
        restaurantPic: null,
        phoneNumber: null,
        image: managerImage,
        manager: widget.manager,
        name: null,
        deliveryFee: null,
        maxDistance: null,
        address: null,
        timeControllers: null,
        location: null,
      ),
      context,
    );
  }

  Future<void> _navigateToMenu(BuildContext context) async {
    if (widget.restaurantId == null) {
      _navigateToNewRestaurant(context);
      return;
    }

    setState(() => isLoading = true);

    List<Category> categories = await Category.getCategoriesByRestaurantId(
            restaurantId: widget.restaurantId!, page: 1, pageSize: 30) ??
        [];

    AnimationNavigation.navigatePush(
      RestaurantItems(
        restaurantId: widget.restaurantId!,
        image: managerImage,
        categories: categories,
        manager: widget.manager,
      ),
      context,
    );

    setState(() => isLoading = false);
  }

  Future<void> _navigateToOrders(BuildContext context) async {
    setState(() => isLoading = true);

    Restaurant? restaurant = await Restaurant.getRestaurantByManagerId(
        managerId: widget.manager.managerid);

    if (restaurant == null) {
      _navigateToNewRestaurant(context);
    } else {
      AnimationNavigation.navigatePush(
        FoodOrderScreen(
            manager: widget.manager, restaurantId: restaurant.restaurantId),
        context,
      );
    }

    setState(() => isLoading = false);
  }

  Future<void> _navigateToOrderHistory(BuildContext context) async {
    setState(() => isLoading = true);

    Restaurant? restaurant = await Restaurant.getRestaurantByManagerId(
        managerId: widget.manager.managerid);

    if (restaurant == null) {
      _navigateToNewRestaurant(context);
    } else {
      AnimationNavigation.navigatePush(
        FoodOrderHistoryScreen(
            manager: widget.manager, restaurantId: restaurant.restaurantId),
        context,
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF201F22),
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(75),
          child: Center(
            child: GlobalAppBar(
              manager: widget.manager,
              isManager: true,
              customer: null,
              image: managerImage,
              username: widget.manager.username,
              shouldPop: false,
            ),
          ),
        ),
        body: AbsorbPointer(
          absorbing: isLoading,
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 30),
                  _buildDashboardRow(
                    context,
                    Assets.images.managerRestaurant.image(),
                    _navigateToRestaurant,
                    Assets.images.managerMenu.image(),
                    _navigateToMenu,
                  ),
                  const SizedBox(height: 20),
                  _buildDashboardRow(
                    context,
                    Assets.images.managerOrders.image(),
                    _navigateToOrders,
                    Assets.images.managerHistory.image(),
                    _navigateToOrderHistory,
                  ),
                ],
              ),
              if (isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardRow(BuildContext context, Widget leftImage,
      Function onLeftTap, Widget rightImage, Function onRightTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(onTap: () => onLeftTap(context), child: leftImage),
        const SizedBox(width: 25),
        GestureDetector(onTap: () => onRightTap(context), child: rightImage),
      ],
    );
  }

  String convertPostgresTimeToHours(String timeStr) {
    int hour = int.parse(timeStr.split(':')[0]);
    return '$hour ${hour < 12 ? 'صبح' : hour < 16 ? 'ظهر' : 'شب'}';
  }
}
