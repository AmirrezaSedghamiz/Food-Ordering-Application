import 'dart:io';

import 'package:data_base_project/GlobalWidgets/GlobalAppBar.dart';
import 'package:data_base_project/GlobalWidgets/GlobalBottomNavigation.dart';
import 'package:data_base_project/GlobalWidgets/UintToFile.dart';
import 'package:data_base_project/SourceDesign/Customer.dart';
import 'package:data_base_project/SourceDesign/Item.dart';
import 'package:data_base_project/SourceDesign/ItemOrder.dart';
import 'package:data_base_project/SourceDesign/Order.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class OrderSummaryPage extends StatefulWidget {
  final Customer customer;
  OrderSummaryPage({super.key, required this.customer});

  @override
  State<OrderSummaryPage> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  late List<ItemOrder> orders;
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
      List<ItemOrder>? fetchedOrders = await ItemOrder.pendingOrders(
        customerId: widget.customer.customerId,
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

  File? customerImage;
  
  Future<void> _initializeCustomerImage() async {
    customerImage = await uint8ListToFile(widget.customer.image);
    setState(() {}); // Update state after loading image
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(75),
              child: GlobalAppBar(
                    manager: null,
                    isManager: false,
                    customer: widget.customer,
                    image: customerImage,
                    username: widget.customer.username,
                    shouldPop: true,
                  ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _scrollController, // Attach the scroll controller
                      itemCount: orders.length +
                          (isLoading ? 1 : 0), // Add one item for loading indicator
                      itemBuilder: (context, index) {
                        if (index == orders.length && isLoading) {
                          // Show loading indicator at the bottom
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                                child: LoadingAnimationWidget.fourRotatingDots(
                                    color: Colors.white, size: 26)),
                          );
                        }
                        return Card(
                          margin: const EdgeInsets.all(10.0),
                          color: Colors.grey[850],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.5,
                                      child: Text(
                                        getAllNames(index),
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFF8F3F0),
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 16.0),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: orders[index].item[0].image == null
                                          ? Image.asset(
                                              'assets/images/Remove-bg.ai_1736362397779 2.png',
                                              width: 100.0,
                                              height: 93.0,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.memory(
                                              orders[index].item[0].image!,
                                              width: 100.0,
                                              height: 93.0,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  orders[index].restaurantName,
                                  style: const TextStyle(color: Color(0xFFF8F3F0 ,) , fontSize: 18),
                                ),
                                const SizedBox(height: 16.0),
                                Text(
                                  'تاریخ : ${orders[index].order.orderTime.formatter.yyyy}/${orders[index].order.orderTime.formatter.mm}/${orders[index].order.orderTime.formatter.dd}',
                                  style: const TextStyle(color: Color(0xFFFEC37D)),
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  'مبلغ قابل پرداخت: ${orders[index].order.orderCost} تومان',
                                  style: const TextStyle(color: Color(0xFFF8F3F0)),
                                ),
                                const SizedBox(height: 18.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFF56949),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(3.0),
                                        ),
                                      ),
                                      child: const Text(
                                        'رفتن به صفحه پرداخت',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.2,)
                ],
              ),
            ),
            backgroundColor: const Color(0xFF201F22)),
        GlobalBottomNavigator(customer: widget.customer,
        isInHome: false,
                isInHistory: false,
                isInProfile: false,
                isInShoppinCart: true,),
      ],
    );
  }
}
