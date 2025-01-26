import 'dart:io';

import 'package:data_base_project/GlobalWidgets/GlobalAppBar.dart';
import 'package:data_base_project/GlobalWidgets/UintToFile.dart';
import 'package:data_base_project/SourceDesign/Customer.dart';
import 'package:data_base_project/SourceDesign/Order.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderSummaryPage extends StatefulWidget {
  final Customer customer;
  final List<Order> orders;
  OrderSummaryPage({super.key, required this.orders, required this.customer});

  @override
  State<OrderSummaryPage> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  late File? customerImage;

  Future<void> _initializeCustomerImage() async {
    customerImage = await uint8ListToFile(widget.customer.image);
    setState(() {});
  }

  @override
  void initState() {
    _initializeCustomerImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: ListView.builder(
            itemCount: widget.orders.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
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
                          Text(
                            'چیز برگر دوبل',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFF8F3F0),
                            ),
                          ),
                          SizedBox(width: 16.0),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              'assets/images/Remove-bg.ai_1736362397779 2.png',
                              width: 100.0,
                              height: 93.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'تاریخ: 1403/11/3',
                        style: TextStyle(color: Color(0xFFFEC37D)),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'تعداد: 1 عدد',
                        style: TextStyle(color: Color(0xFFF8F3F0)),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'فست فودی مش رجب',
                        style: TextStyle(color: Color(0xFFF8F3F0)),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'مبلغ قابل پرداخت: 430000 تومان',
                        style: TextStyle(color: Color(0xFFF8F3F0)),
                      ),
                      SizedBox(height: 18.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            child: Text(
                              'رفتن به صفحه پرداخت',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFF56949),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
        backgroundColor: Color(0xFF201F22));
  }
}
