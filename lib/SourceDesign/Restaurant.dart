// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import 'package:postgres/postgres.dart';

class Restaurant {
  int restaurantId;
  String name;
  String address;
  String phoneNumber;
  LatLng point;
  int deliveryRadius;
  double deliveryFee;
  Uint8List image;
  int managerId;

  Restaurant({
    required this.restaurantId,
    required this.name,
    required this.phoneNumber,
    required this.address,
    required this.point,
    required this.deliveryRadius,
    required this.deliveryFee,
    required this.image,
    required this.managerId,
  });

  static Future<Restaurant?> insertRestaurant({
    required String name,
    required String address,
    required String phoneNumber,
    required LatLng point,
    required int deliveryRadius,
    required double deliveryFee,
    required File image,
    required int managerId,
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
      var result = await connection.execute(
          Sql.named(
              'CALL insert_restaurant(@name, @addressstring, @longtitude, @latitude , @phonenumber , @deliveryradius , @image ,@managerid_param, @deliveryfee)'),
          parameters: {
            'name': name,
            'addressstring': address,
            'longtitude': point.longitude,
            'latitude': point.latitude,
            'phonenumber': phoneNumber,
            'deliveryradius': deliveryRadius,
            'image': base64Encode(await image.readAsBytes()),
            'managerid_param': managerId,
            'deliveryfee': deliveryFee,
          });
      final restaurant =
          Restaurant.getRestaurantByManagerId(managerId: managerId);
      return restaurant;
    } catch (e) {
      print('Error: $e');
    } finally {
      await connection.close();
    }
  }

  static Future<Restaurant?> getRestaurantByManagerId(
      {required int managerId}) async {
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
      var result = await connection.execute(
          Sql.named('SELECT get_restaurant_by_manager(@input_manager)'),
          parameters: {
            'input_manager': managerId,
          });
      dynamic finalRes = result[0][0];
      final value = Restaurant.fromMap(finalRes['restaurant']);
      return value;
    } catch (e) {
      print('Error: $e');
    } finally {
      await connection.close();
    }
    return null;
  }

  factory Restaurant.fromMap(Map<String, dynamic> map) {
    return Restaurant(
        restaurantId: map['restaurantid'] as int,
        phoneNumber: map['phonenumber'],
        name: map['name'] as String,
        address: map['addressstring'] as String,
        point: LatLng(map['latitude'], map['longtitude']),
        deliveryRadius: map['deliveryradius'] as int,
        image: base64Decode(map['image']),
        managerId: map['managerid'],
        deliveryFee: double.parse(map['deliveryfee'].toString()));
  }

  factory Restaurant.fromJson(String source) =>
      Restaurant.fromMap(json.decode(source) as Map<String, dynamic>);
}
