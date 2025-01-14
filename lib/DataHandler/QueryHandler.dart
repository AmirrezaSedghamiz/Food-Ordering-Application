import 'package:data_base_project/SourceDesign/Admin.dart';
import 'package:data_base_project/SourceDesign/Customer.dart';
import 'package:data_base_project/SourceDesign/Manager.dart';
import 'package:postgres/postgres.dart';

class LoginQuery {
  static Future<dynamic> login({
    required String username,
    required String password,
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
          Sql.named('SELECT login_user(@input_username, @input_password)'),
          parameters: {
            'input_username': username,
            'input_password': password,
          });
      dynamic finalUser = result[0][0];
      if (finalUser['role'] == 'customer') {
        return Customer.fromMap(finalUser['user']);
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
