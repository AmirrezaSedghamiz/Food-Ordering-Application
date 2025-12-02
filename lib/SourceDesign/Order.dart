// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'package:data_base_project/DataHandler/QueryHandler.dart';

import 'package:data_base_project/SourceDesign/ItemOrder.dart';
import 'package:postgres/postgres.dart';
import 'package:shamsi_date/shamsi_date.dart';

class Order {
  int orderId;
  Jalali orderTime;
  OrderStatus status;
  String orderDetails;
  double orderCost;
  Order({
    required this.orderId,
    required this.orderTime,
    required this.orderCost,
    required this.status,
    required this.orderDetails,
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    List<OrderStatus> statuses = [
      OrderStatus.REJECTED,
      OrderStatus.PENDING,
      OrderStatus.ACCEPTED
    ];
    return Order(
        orderId: map['order_id'] as int,
        orderTime:
            Jalali.fromDateTime(DateTime.parse(map['order_time'].toString())),
        orderDetails: '',
        orderCost: double.parse(map['order_cost'].toString()),
        status: statuses[int.parse(map['status'].toString())]);
  }

  factory Order.fromJson(String source) =>
      Order.fromMap(json.decode(source) as Map<String, dynamic>);

  static Future<void> updateOrder({
    required int orderId,
    required int status,
  }) async {
    final connection = await Connection.open(
        Endpoint(
          host: dbHost ?? "",
          port: int.parse(dbPort ?? "8000"),
          database: dbDatabase ?? "",
          username: dbUsername ?? "",
          password: dbPassword ?? "",
        ),
        settings: const ConnectionSettings(
          sslMode: SslMode.disable,
        ));

    try {
      connection;
      print('Connected to the database.');

      var result = await connection.execute(
          Sql.named('CALL update_order_status(@order_id, @new_status)'),
          parameters: {
            'order_id': orderId,
            'new_status': status,
          });
      print("SUCCESSFUL!");
      return;
    } catch (e) {
      print('Error: $e');
    } finally {
      await connection.close();
      print('Connection closed.');
    }
  }
}

enum OrderStatus { REJECTED, PENDING, ACCEPTED }
