import 'package:data_base_project/SourceDesign/Address.dart';
import 'package:data_base_project/SourceDesign/Admin.dart';
import 'package:data_base_project/SourceDesign/Customer.dart';
import 'package:data_base_project/SourceDesign/Manager.dart';
import 'package:postgres/postgres.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final dbHost = dotenv.env['host'];
final dbPort = dotenv.env['port'];
final dbDatabase  = dotenv.env['database'];
final dbUsername  = dotenv.env['username'];
final dbPassword  = dotenv.env['password'];

class LoginQuery {
  static Future<dynamic> login({
    required String username,
    required String password,
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
          Sql.named('SELECT login_user(@input_username, @input_password)'),
          parameters: {
            'input_username': username,
            'input_password': password,
          });
      dynamic finalUser = result[0][0];
      if (finalUser['role'] == 'customer') {
        Customer customer = Customer.fromMap(finalUser['user']);
        print(customer.toString());
        var addresses =
            (await Address.getUserAddress(username: customer.username)) ?? [];
        for (var i in addresses) {
          print(i.toString());
          customer.addresses.add(i);
          if (i.isSelected) {
            customer.selectedAddress = i;
          }
        }
        customer.addresses = addresses;
        return customer;
      } else if (finalUser['role'] == 'manager') {
        return Manager.fromMap(finalUser['user']);
      } else if (finalUser['role'] == 'admin') {
        return Admin.fromMap(finalUser['user']);
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      await connection.close();
    }
  }
}
