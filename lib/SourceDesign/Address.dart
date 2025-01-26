// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:latlong2/latlong.dart';
import 'package:postgres/postgres.dart';

class Address {
  int addressId;
  String address;
  bool isSelected;
  LatLng point;
  Address({
    required this.addressId,
    required this.isSelected,
    required this.address,
    required this.point,
  });

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
        isSelected: map['isselected'],
        addressId: map['addressid'],
        address: map['addressstring'],
        point: LatLng(double.parse(map['latitude'].toString()),
            double.parse(map['longtitude'].toString())));
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
      connection;
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

  static Future<List<Address>?> getUserAddress(
      {required String username}) async {
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
          Sql.named('SELECT get_user_addresses(@username, @page, @page_size)'),
          parameters: {
            'username': username,
            'page': 1,
            'page_size': 30,
          });
      dynamic finalData = result[0][0];
      List<Address> addresses = [];
      for (var i in finalData['addresses'] ?? []) {
        addresses.add(Address.fromMap(i));
      }
      return addresses;
    } catch (e) {
      print('Error: $e');
    } finally {
      await connection.close();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "addressid" : addressId,
      "addressstring": address,
      "longtitude": point.longitude,
      "latitude": point.latitude,
      "isselected": isSelected,
    };
  }

  static Future<void> updateAddresses(
      {required int customerId,
      required List<Address> addresses,
      required List<int> existingIds}) async {
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
      final listAddresses = [];
      for (var i in addresses) {
        listAddresses.add(i.toJson());
      }
      final dict = {'existing': existingIds, 'new': listAddresses};
      print(dict);
      var result = await connection.execute(
          Sql.named('CALL manage_addresses(@p_customerid, @p_addresses)'),
          parameters: {
            'p_customerid': customerId,
            'p_addresses': dict,
          });
      print('SUCCESSS');
      return;
    } catch (e) {
      print('Error: $e');
    } finally {
      await connection.close();
    }
  }

  @override
  String toString() {
    return 'Address(addressId: $addressId, address: $address, isSelected: $isSelected, point: $point)';
  }
}
