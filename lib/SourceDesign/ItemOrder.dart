// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:data_base_project/DataHandler/QueryHandler.dart';

import 'package:data_base_project/SourceDesign/Address.dart';
import 'package:data_base_project/SourceDesign/Customer.dart';
import 'package:data_base_project/SourceDesign/Item.dart';
import 'package:data_base_project/SourceDesign/Order.dart';
import 'package:postgres/postgres.dart';

class ItemOrder {
  List<ItemQuantity> item;
  Order order;
  int restaurantId;
  String restaurantName;
  ItemOrder({
    required this.item,
    required this.restaurantId,
    required this.restaurantName,
    required this.order,
  });

  static Future<List<ItemOrder>?> nonPendingOrders({
    required int customerId,
    required int pageSize,
    required int pageNumber,
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
          Sql.named(
              'SELECT get_non_pending_orders(@customer_id, @limit_rows, @offset_rows)'),
          parameters: {
            'customer_id': customerId,
            'limit_rows': pageSize,
            'offset_rows': pageNumber
          });
      dynamic finalResult = result[0][0];
      List<ItemOrder> itemOrders = [];
      for (var i in finalResult) {
        if (i['order_details']['restaurant_id'] == null) continue;
        itemOrders.add(ItemOrder(
          restaurantId: i['order_details']['restaurant_id'],
          restaurantName: i['order_details']['restaurant_name'],
          item: (i['items'] as List)
              .map((item) => ItemQuantity.fromMap(item))
              .toList(),
          order: Order.fromMap(i['order_details']),
        ));
      }
      print("SUCCESSFUL!");
      return itemOrders;
    } catch (e) {
      print('Error: $e');
    } finally {
      await connection.close();
      print('Connection closed.');
    }
  }

  static Future<List<ItemOrder>?> pendingOrders({
    required int customerId,
    required int pageSize,
    required int pageNumber,
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
          Sql.named(
              'SELECT get_pending_orders(@customer_id, @limit_rows, @offset_rows)'),
          parameters: {
            'customer_id': customerId,
            'limit_rows': pageSize,
            'offset_rows': pageNumber
          });
      dynamic finalResult = result[0][0];
      print(finalResult.length);
      List<ItemOrder> itemOrders = [];
      for (var i in finalResult) {
        if (i['order_details']['restaurant_id'] == null) continue;
        itemOrders.add(ItemOrder(
          restaurantId: i['order_details']['restaurant_id'],
          restaurantName: i['order_details']['restaurant_name'].toString(),
          item: (i['items'] as List)
              .map((item) => ItemQuantity.fromMap(item))
              .toList(),
          order: Order.fromMap(i['order_details']),
        ));
      }
      print("SUCCESSFUL!");
      return itemOrders;
    } catch (e) {
      print('Error: $e');
    } finally {
      await connection.close();
      print('Connection closed.');
    }
  }

  static Future<void> insertOrder(
      {required int addressId,
      required int restaurantId,
      required Map<Item, int> itemQuantity}) async {
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
    List<Map<String, dynamic>> json = itemQuantity.entries.map((entry) {
      return {
        'itemid': entry.key.itemid,
        'quantity': entry.value,
        'itemordercost': entry.key.cost * entry.value,
      };
    }).toList();
    try {
      connection;
      print("WOOOOOOOOOOOOOOOOY");
      var result = await connection.execute(
          Sql.named(
              'SELECT create_order(@input_addressid ,@input_restaurantid, @input_items)'),
          parameters: {
            'input_addressid': addressId,
            'input_restaurantid': restaurantId,
            'input_items': jsonEncode(json)
          });
      await connection.close();
      return;
    } catch (e) {
      print('Error: $e');
    } finally {
      await connection.close();
    }
    return null;
  }
}

class ItemOrderManager {
  List<ItemQuantity> item;
  Order order;
  Customer customer;

  ItemOrderManager({
    required this.item,
    required this.order,
    required this.customer,
  });

  static Future<List<ItemOrderManager>?> nonPendingOrdersManager({
    required int restaurantId,
    required int pageSize,
    required int pageNumber,
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
          Sql.named(
              'SELECT get_non_pending_orders_for_manager(@restaurant_id, @page_size, @page_number)'),
          parameters: {
            'restaurant_id': restaurantId,
            'page_size': pageSize,
            'page_number': pageNumber
          });
      dynamic finalResult = result[0][0];
      List<ItemOrderManager> itemOrders = [];
      for (var i in finalResult) {
        ItemOrderManager temp = ItemOrderManager(
          customer: Customer.fromMap(i['customer_details']),
          item: (i['items'] as List)
              .map((item) => ItemQuantity.fromMap(item))
              .toList(),
          order: Order.fromMap(i['order_details']),
        );
        temp.customer.selectedAddress = Address.fromMap(i['address_details']);
        itemOrders.add(temp);
      }
      print("SUCCESSFUL!");
      return itemOrders;
    } catch (e) {
      print('Error: $e');
    } finally {
      await connection.close();
      print('Connection closed.');
    }
  }

  static Future<List<ItemOrderManager>?> pendingOrdersManager({
    required int restaurantId,
    required int pageSize,
    required int pageNumber,
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
          Sql.named(
              'SELECT get_pending_orders_for_manager(@restaurant_id, @page_size, @page_number)'),
          parameters: {
            'restaurant_id': restaurantId,
            'page_size': pageSize,
            'page_number': pageNumber
          });
      dynamic finalResult = result[0][0];
      List<ItemOrderManager> itemOrders = [];
      for (var i in finalResult) {
        ItemOrderManager temp = ItemOrderManager(
          customer: Customer.fromMap(i['customer_details']),
          item: (i['items'] as List)
              .map((item) => ItemQuantity.fromMap(item))
              .toList(),
          order: Order.fromMap(i['order_details']),
        );
        temp.customer.selectedAddress = Address.fromMap(i['address_details']);
        itemOrders.add(temp);
      }
      print("SUCCESSFUL!");
      return itemOrders;
    } catch (e) {
      print('Error: $e');
    } finally {
      await connection.close();
      print('Connection closed.');
    }
  }
}
