import 'dart:convert';
import 'dart:typed_data';
import 'package:data_base_project/DataHandler/QueryHandler.dart';

import 'package:data_base_project/SourceDesign/Customer.dart';
import 'package:data_base_project/SourceDesign/Manager.dart';
import 'package:data_base_project/SourceDesign/Restaurant.dart';
import 'package:postgres/postgres.dart';

class Admin {
  int adminId;
  String username;
  String phoneNumber;
  Uint8List? image;

  factory Admin.fromMap(Map<String, dynamic> map) {
    return Admin(
      adminId: map['adminid'] as int,
      username: map['username'] as String,
      phoneNumber: map['phonenumber'] as String,
      image: map['image'] != null ? base64Decode(map['image'] as String) : null,
    );
  }

  Admin({
    required this.adminId,
    required this.username,
    required this.phoneNumber,
    this.image,
  });

  static Future<List<Customer>?> getAllCustomer({
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
      var result = await connection.execute(
          Sql.named(
              'SELECT get_customers_with_pagination(@page_size ,@page_number)'),
          parameters: {
            'page_size': pageSize,
            'page_number': pageNumber,
          });
      dynamic finalRes = result[0][0];
      print(finalRes.length);
      List<Customer> customers = [];
      for (var i in finalRes) {
        customers.add(Customer.fromMap(i));
      }
      await connection.close();
      return customers;
    } catch (e) {
      print('Error: $e');
    } finally {
      await connection.close();
    }
    return null;
  }

  static Future<void> insertAdmin({
    required String username,
    required String password,
    required String phoneNumber,
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
          Sql.named('CALL insert_admin(@username, @password, @phoneNumber)'),
          parameters: {
            'username': username,
            'password': password,
            'phoneNumber': phoneNumber
          });
      print("SUCCESSFUL!");
    } catch (e) {
      print('Error: $e');
    } finally {
      await connection.close();
      print('Connection closed.');
    }
  }

  static Future<void> deleteCustomer({required int customerId}) async {
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
          Sql.named('CALL delete_customer_by_id(@input_customerid)'),
          parameters: {'input_customerid': customerId});
      print("SUCCESSFUL!");
    } catch (e) {
      print('Error: $e');
    } finally {
      await connection.close();
      print('Connection closed.');
    }
  }

  static Future<void> deleteManager({required int managerId}) async {
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
          Sql.named('CALL delete_manager_and_restaurant(@input_managerid)'),
          parameters: {'input_managerid': managerId});
      print("SUCCESSFUL!");
    } catch (e) {
      print('Error: $e');
    } finally {
      await connection.close();
      print('Connection closed.');
    }
  }

  static Future<void> deleteRestaurant({required int restaurantId}) async {
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
          Sql.named('CALL delete_restaurant_by_id(@p_restaurantid)'),
          parameters: {'p_restaurantid': restaurantId});
      print("SUCCESSFUL!");
    } catch (e) {
      print('Error: $e');
    } finally {
      await connection.close();
      print('Connection closed.');
    }
  }

  static Future<List<ManagerRestaurant>?> getManagerRestaurants({
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
              'SELECT get_managers_with_restaurants(@page_size ,@page_number)'),
          parameters: {
            'page_size': pageSize,
            'page_number': pageNumber,
          });
      dynamic finalRes = result[0][0];
      List<ManagerRestaurant> managerRestaurants = [];
      for (var i in finalRes) {
        managerRestaurants.add(ManagerRestaurant.fromMap(i));
      }
      print("SUCCESSFUL!");
      return managerRestaurants;
    } catch (e) {
      print('Error: $e');
    } finally {
      await connection.close();
      print('Connection closed.');
    }
  }

  static Future<void> updateManager({
    required int managerId,
    required String restaurantName,
    required String managerName,
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
          Sql.named('CALL update_manager_and_first_restaurant('
              '@input_managerid, @newUsername, @newRestaurantName)'),
          parameters: {
            'input_managerid': managerId,
            'newUsername': managerName,
            'newRestaurantName': restaurantName,
          });

      print("SUCCESSFUL!");
    } catch (e) {
      print('Error: $e');
    } finally {
      await connection.close();
      print('Connection closed.');
    }
  }

  static Future<List<ManagerRestaurant>?> getManagerRestaurantsForRestaurants({
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
              'SELECT get_restaurants_with_managers(@page_size ,@page_number)'),
          parameters: {
            'page_size': pageSize,
            'page_number': pageNumber,
          });
      dynamic finalRes = result[0][0];
      List<ManagerRestaurant> managerRestaurants = [];
      for (var i in finalRes) {
        managerRestaurants.add(ManagerRestaurant.fromMap(i));
      }
      print("SUCCESSFUL!");
      return managerRestaurants;
    } catch (e) {
      print('Error: $e');
    } finally {
      await connection.close();
      print('Connection closed.');
    }
  }
}
