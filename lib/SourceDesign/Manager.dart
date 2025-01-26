// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:data_base_project/DataHandler/QueryHandler.dart';
import 'package:postgres/postgres.dart';

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
          host: '163.5.94.58',
          port: 5432,
          database: 'mashmammad',
          username: 'postgres',
          password: 'Erfank2004@',
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
          host: '163.5.94.58',
          port: 5432,
          database: 'mashmammad',
          username: 'postgres',
          password: 'Erfank2004@',
        ),
        settings: const ConnectionSettings(
          sslMode: SslMode.disable,
        ));

    try {
      connection;
      print('Connected to the database.');

      var result = await connection.execute(
          Sql.named('CALL insert_manager(@username, @password, @phoneNumber)'),
          parameters: {
            'username': username,
            'password': password,
            'phoneNumber': phoneNumber
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
