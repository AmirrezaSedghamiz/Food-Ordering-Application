import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderSummaryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF484848),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(0xFFF56949),
                      child:
                          Icon(CupertinoIcons.person, color: Color(0xFFF8F3F0)),
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      'داریا بدیعی',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Color(0xFFF8F3F0),
                      ),
                    )
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.logout, color: Color(0xFFF8F3F0)),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          body: Center(
            child: Card(
              margin: EdgeInsets.all(10.0),
              color: Colors.grey[850],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
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
                    SizedBox(height: 10.0),
                    Text(
                      'پرداخت شده',
                      style: TextStyle(
                        color: Color(0xFFFEC37D),
                        decoration: TextDecoration.underline,
                        decorationColor: Color(0xFFFEC37D),
                      ),
                    ),
                    SizedBox(height: 18.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            'مایلی دوباره سفارش بدی؟',
                            style: TextStyle(color: Color(0xFFF8F3F0)),
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
            ),
          ),
          backgroundColor: Color(0xFF201F22)),
    );
  }
}
