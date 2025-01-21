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
    connection;
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

