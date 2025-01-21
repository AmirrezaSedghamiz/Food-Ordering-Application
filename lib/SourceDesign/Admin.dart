import 'dart:convert';
import 'dart:typed_data';

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

  static Future<void> insertAdmin({
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
}
