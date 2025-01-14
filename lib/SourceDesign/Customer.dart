// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:data_base_project/DataHandler/QueryHandler.dart';
import 'package:latlong2/latlong.dart';
import 'package:postgres/postgres.dart';

import 'package:data_base_project/SourceDesign/Address.dart';

class Customer {
  int customerId;
  String username;
  String phoneNumber;
  Uint8List? image;
  Address? selectedAddress;
  List<Address>? addresses;

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

  static Future<Customer?> insertCustomer({
    required String username,
    required String password,
    required String phoneNumber,
    required String addressString,
    required LatLng latLng,
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
      await connection;
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
      Address.insertAddress(
          addressString: addressString,
          latLng: latLng,
          isSelected: true,
          customerID: customer.customerId);
      var address = await Address.getUserAddress(username: username);
      List<Address> addresses = [];
      for (var i in address) {
        addresses.add(Address.fromMap(i));
        if (i['isselected']) {
          customer.selectedAddress = Address.fromMap(i);
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
  }
}
