// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:latlong2/latlong.dart';
import 'package:postgres/postgres.dart';

import 'package:data_base_project/DataHandler/QueryHandler.dart';
import 'package:data_base_project/SourceDesign/Address.dart';

class Customer {
  int customerId;
  String username;
  String phoneNumber;
  Uint8List? image;
  Address? selectedAddress;
  List<Address> addresses = [];

  Customer({
    required this.customerId,
    required this.username,
    required this.phoneNumber,
    this.image,
  });

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      customerId: map['customerid'] as int,
      username: map['username'] as String,
      phoneNumber: map['phonenumber'] as String,
      image: map['image'] != null ? base64Decode(map['image'] as String) : null,
    );
  }

  static Future<void> updateCustomer({
    required String username,
    required int customerId,
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
              'CALL update_customer(@p_customerid ,@p_username, @p_phonenumber, @p_image)'),
          parameters: {
            'p_customerid': customerId,
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

  static Future<Customer?> insertCustomer({
    required String username,
    required String password,
    required String phoneNumber,
    required String addressString,
    required LatLng latLng,
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
              'CALL insert_customer(@p_username, @p_password, @p_phoneNumber)'),
          parameters: {
            'p_username': username,
            'p_password': password,
            'p_phoneNumber': phoneNumber
          });
      Customer customer =
          await LoginQuery.login(username: username, password: password);
      final data = await Address.insertAddress(
          addressString: addressString,
          latLng: latLng,
          isSelected: true,
          customerID: customer.customerId);
      var addresses = (await Address.getUserAddress(username: username)) ?? [];
      for (var i in addresses) {
        customer.addresses.add(i);
        if (i.isSelected) {
          customer.selectedAddress = i;
        }
      }
      customer.addresses = addresses;
      await connection.close();
      return customer;
    } catch (e) {
      print('Error: $e');
    } finally {
      await connection.close();
    }
    return null;
  }

  @override
  String toString() {
    return 'Customer(customerId: $customerId, username: $username, phoneNumber: $phoneNumber, image: $image, selectedAddress: $selectedAddress, addresses: $addresses)';
  }
}
