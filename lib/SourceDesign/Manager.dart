// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:postgres/postgres.dart';

import 'package:data_base_project/DataHandler/QueryHandler.dart';
import 'package:data_base_project/SourceDesign/Restaurant.dart';

class Manager {
  int managerid;
  String username;
  String phoneNumber;
  Uint8List? image;

  factory Manager.fromMap(Map<String, dynamic> map) {
    return Manager(
      managerid: map['managerid'] as int,
      username: map['username'] as String,
      phoneNumber: map['phonenumber'] as String,
      image: map['image'] != null ? base64Decode(map['image'] as String) : null,
    );
  }

  Manager({
    required this.managerid,
    required this.username,
    required this.phoneNumber,
    this.image,
  });

  static Future<void> updateManager({
    required String username,
    required int managerId,
    required String phoneNumber,
    required File? image,
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
      print("WOOOOOOOOOOOOOOOOY");
      var result = await connection.execute(
          Sql.named(
              'CALL update_manager(@p_managerid ,@p_username, @p_phonenumber, @p_image)'),
          parameters: {
            'p_managerid': managerId,
            'p_username': username,
            'p_phonenumber': phoneNumber,
            'p_image':
                image == null ? null : base64Encode(await image.readAsBytes()),
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

  static Future<Manager?> insertManager({
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
          Sql.named('CALL insert_manager(@username, @password, @phonenumber)'),
          parameters: {
            'username': username,
            'password': password,
            'phonenumber': phoneNumber
          });
      Manager manager =
          await LoginQuery.login(username: username, password: password);
      print("SUCCESSFUL!");
      return manager;
    } catch (e) {
      print('Error: $e');
    } finally {
      await connection.close();
      print('Connection closed.');
    }
  }
}

class ManagerRestaurant {
  Manager manager;
  Restaurant? restaurant;
  ManagerRestaurant({
    required this.manager,
    required this.restaurant,
  });

  factory ManagerRestaurant.fromMap(Map<String, dynamic> map) {
    return ManagerRestaurant(
      manager: Manager.fromMap(map['manager'] as Map<String, dynamic>),
      restaurant: map['restaurant'] != null
          ? Restaurant.fromMap(map['restaurant'] as Map<String, dynamic>)
          : null,
    );
  }

  factory ManagerRestaurant.fromJson(String source) =>
      ManagerRestaurant.fromMap(json.decode(source) as Map<String, dynamic>);
}
