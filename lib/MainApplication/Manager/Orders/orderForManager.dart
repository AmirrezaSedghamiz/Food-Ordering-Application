import 'dart:io';

import 'package:data_base_project/GlobalWidgets/GlobalAppBar.dart';
import 'package:data_base_project/GlobalWidgets/UintToFile.dart';
import 'package:data_base_project/SourceDesign/ItemOrder.dart';
import 'package:data_base_project/SourceDesign/Manager.dart';
import 'package:data_base_project/SourceDesign/Order.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class FoodOrderScreen extends StatefulWidget {
  const FoodOrderScreen(
      {super.key, required this.manager, required this.restaurantId});

  final Manager manager;
  final int restaurantId;

  @override
  State<FoodOrderScreen> createState() => _FoodOrderScreenState();
}

class _FoodOrderScreenState extends State<FoodOrderScreen> {
  File? managerImage;
  List<ItemOrderManager> orders = [];

  Future<void> _initializeCustomerImage() async {
    managerImage = await uint8ListToFile(widget.manager.image);

    setState(() {});
  }

  bool isLoading = false;
  int pageNumber = 1;
  int pageSize = 5;
  final ScrollController _scrollController = ScrollController();

  String getAllNames(int index) {
    String str = '';
    for (var i in orders[index].item) {
      if (i == orders[index].item.last) {
        str += '${i.name} ${i.quantity} عدد';
        break;
      }
      str += '${i.name} ${i.quantity} عدد - ';
    }
    return str;
  }

  Future<void> _loadOrders(int pageNumber) async {
    if (isLoading) return; // Prevent multiple simultaneous loads

    setState(() {
      isLoading = true;
    });

    try {
      List<ItemOrderManager>? fetchedOrders =
          await ItemOrderManager.pendingOrdersManager(
        restaurantId: widget.restaurantId,
        pageSize: pageSize,
        pageNumber: pageNumber,
      );

      if (fetchedOrders != null) {
        setState(() {
          orders.addAll(fetchedOrders); // Add fetched orders to the list
        });
      }
    } catch (e) {
      print("Error loading orders: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // If we've reached the bottom of the list, load more orders
      pageNumber++;
      _loadOrders(pageNumber);
    }
  }

  @override
  void initState() {
    orders = []; // Initialize the orders list
    _scrollController.addListener(_scrollListener);
    super.initState();
    _loadOrders(pageNumber);
    _initializeCustomerImage();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF201F22),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(75),
          child: Center(
            child: GlobalAppBar(
              manager: widget.manager,
              isManager: true,
              customer: null,
              image: managerImage,
              username: widget.manager.username,
              shouldPop: true,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'سفارشات',
                        style: TextStyle(
                          color: Color(0xFFFEC37D),
                          fontSize: 20.0,
                          fontFamily: "DanaFaNum",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox()
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                ListView.builder(
                    shrinkWrap: true,
                    controller: _scrollController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: orders.length +
                        (isLoading
                            ? 1
                            : 0), // Add one item for loading indicator
                    itemBuilder: (context, index) {
                      if (index == orders.length && isLoading) {
                        // Show loading indicator at the bottom
                        return Center(
                            child: LoadingAnimationWidget.fourRotatingDots(
                                color: Colors.white, size: 26));
                      }
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFF484848),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                getAllNames(index),
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  fontFamily: "DanaFaNum",
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              const Divider(
                                color: Color(0xFFF8F3F0),
                                thickness: 0.5,
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                'تاریخ : ${orders[index].order.orderTime.formatter.yyyy}/${orders[index].order.orderTime.formatter.mm}/${orders[index].order.orderTime.formatter.dd}',
                                style: const TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: "DanaFaNum",
                                    color: Color(0xFFF8F3F0)),
                              ),
                              const SizedBox(height: 4.0),
                              const Divider(
                                color: Color(0xFFF8F3F0),
                                thickness: 0.5,
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                'سفارش دهنده: ${orders[index].customer.username}',
                                style: const TextStyle(
                                    fontSize: 16.0,
                                    color: Color(0xFFF8F3F0),
                                    fontFamily: "DanaFaNum"),
                              ),
                              const SizedBox(height: 4.0),
                              const Divider(
                                color: Color(0xFFF8F3F0),
                                thickness: 0.5,
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                'آدرس: ${orders[index].customer.selectedAddress!.address}',
                                style: const TextStyle(
                                    fontSize: 16.0,
                                    color: Color(0xFFF8F3F0),
                                    fontFamily: "DanaFaNum"),
                                maxLines: 2,
                              ),
                              const SizedBox(height: 8.0),
                              const Divider(
                                color: Color(0xFFF8F3F0),
                                thickness: 0.5,
                              ),
                              const SizedBox(height: 8.0),
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Order.updateOrder(
                                          orderId: orders[index].order.orderId,
                                          status: 2);
                                      setState(() {
                                        orders.removeAt(index);
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF5CB338),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(3.0),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 19.0, vertical: 5.0),
                                    ),
                                    child: const Text(
                                      'تایید',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Color(0xFFF8F3F0),
                                          fontFamily: "DanaFaNum"),
                                    ),
                                  ),
                                  const SizedBox(width: 20.0),
                                  ElevatedButton(
                                    onPressed: () {
                                      Order.updateOrder(
                                          orderId: orders[index].order.orderId,
                                          status: 0);
                                      setState(() {
                                        orders.removeAt(index);
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFFB4141),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(3.0),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 19.0, vertical: 5.0),
                                    ),
                                    child: const Text(
                                      'لغو',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Color(0xFFF8F3F0),
                                          fontFamily: "DanaFaNum"),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
