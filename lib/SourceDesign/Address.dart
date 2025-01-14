// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:latlong2/latlong.dart';
import 'package:postgres/postgres.dart';

class Address {
  int addressId;
  String address;
  LatLng point;
  Address({
    required this.addressId,
    required this.address,
    required this.point,
  });

    factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      addressId: map['addressid'],
      address: map['addressstring'],
      point: LatLng(map['latitude'], map['longtitude']) 
    );
  }

  static Future<void> insertAddress({
    required String addressString,
    required LatLng latLng,
    required bool isSelected,
    required int customerID,
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
              'CALL insert_address(@addressstring, @longtitude, @latitude, @isselected, @customerid)'),
          parameters: {
            'addressstring': addressString,
            'latitude': latLng.latitude,
            'longtitude': latLng.longitude,
            'isselected': isSelected,
            'customerid': customerID
          });
    } catch (e) {
      print('Error: $e');
    } finally {
      await connection.close();
    }
  }

  static Future<dynamic> getUserAddress({required String username}) async {
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
          Sql.named('SELECT get_user_addresses(@username)'),
          parameters: {'username': username});
      return result[0][0];
    } catch (e) {
      print('Error: $e');
    } finally {
      await connection.close();
    }
  }
}
