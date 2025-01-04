import 'dart:io';
import 'package:flutter/services.dart';
import 'package:postgres/postgres.dart';

Future<void> executeQuery(String filePath) async {
  final query = await rootBundle.loadString(filePath);

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
    print('Connected to the database.');

    // Example query
    List<List<dynamic>> results = await connection.execute(query);
    for (var row in results) {
      print('Row: $row');
    }
  } catch (e) {
    print('Error connecting to the database: $e');
  } finally {
    await connection.close();
    print('Connection closed.');
  }
}

// Future<void> insertRestaurant({
//   required String name,
//   required String address,
//   required double locationX,
//   required double locationY,
//   required String phoneNumber,
//   required int deliveryRadius,
//   required String image,
// }) async {

//   final connection = await Connection.open(
//       Endpoint(
//         host: '10.0.2.2',
//         port: 5432,
//         database: 'DataBaseProject',
//         username: 'postgres',
//         password: 'amir7007',
//       ),
//       settings: const ConnectionSettings(
//         sslMode: SslMode.disable,
//       ));


//   try {
//     await connection;
//     print('Connected to the database.');

//     // Call the stored procedure with parameters
    
//     var result = await connection.execute(
//       Sql.named('CALL insert_restaurant(@name, @address, @locationx, @locationy, @phonenumber, @deliveryradius, @image)'),
//       parameters:{
//         'name': name,
//         'address': address,
//         'locationx': locationX,
//         'locationy': locationY,
//         'phonenumber': phoneNumber,
//         'deliveryradius': deliveryRadius,
//         'image': image,
//       },
//     );

//     print('Inserted restaurant: $name');
//   } catch (e) {
//     print('Error: $e');
//   } finally {
//     await connection.close();
//     print('Connection closed.');
//   }
// }