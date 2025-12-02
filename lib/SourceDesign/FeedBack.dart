// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:data_base_project/DataHandler/QueryHandler.dart';

import 'package:data_base_project/SourceDesign/Customer.dart';
import 'package:postgres/postgres.dart';

class FeedBack {
  int feedbackid;
  String comment;
  int rating;
  Customer customer;

  FeedBack({
    required this.feedbackid,
    required this.comment,
    required this.rating,
    required this.customer,
  });

  static Future<int?> isAssociated(
      {required int itemid, required int customerId}) async {
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
      print('Connected to the database.');

      var result = await connection.execute(
          Sql.named(
              'SELECT check_customer_item_association(@input_customerid, @input_itemid)'),
          parameters: {
            'input_customerid': customerId,
            'input_itemid': itemid,
          });
      print("SUCCESSFUL!");
      return result[0][0] as int;
    } catch (e) {
      print('Error: $e');
    } finally {
      await connection.close();
      print('Connection closed.');
    }
  }

  static Future<List<FeedBack>?> getComments({
    required int itemId,
    required int pageSize,
    required int pageNumber,
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
      print('Connected to the database.');

      var result = await connection.execute(
          Sql.named(
              'SELECT get_item_feedback(@input_itemid, @page_size, @page_number)'),
          parameters: {
            'input_itemid': itemId,
            'page_size': pageSize,
            'page_number': pageNumber
          });
      dynamic finalResult = result[0][0];
      List<FeedBack> comments = [];
      for (var i in finalResult) {
        comments.add(FeedBack.fromMap(i));
      }
      print("SUCCESSFUL!");
      return comments;
    } catch (e) {
      print('Error: $e');
    } finally {
      await connection.close();
      print('Connection closed.');
    }
  }

  static Future<void> insertComment({
    required int itemOrderId,
    required int rating,
    required String body,
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
      print('Connected to the database.');

      var result = await connection.execute(
          Sql.named(
              'CALL insert_feedback(@input_itemorderid, @input_body, @input_rating)'),
          parameters: {
            'input_itemorderid': itemOrderId,
            'input_body': body,
            'input_rating': rating
          });
      print("SUCCESSFUL!");
      return;
    } catch (e) {
      print('Error: $e');
    } finally {
      await connection.close();
      print('Connection closed.');
    }
  }

  factory FeedBack.fromMap(Map<String, dynamic> map) {
    return FeedBack(
      feedbackid: map['feedback_details']['feedbackid'] as int,
      comment: map['feedback_details']['body'] as String,
      rating: map['feedback_details']['rating'] as int,
      customer:
          Customer.fromMap(map['customer_details'] as Map<String, dynamic>),
    );
  }

  factory FeedBack.fromJson(String source) =>
      FeedBack.fromMap(json.decode(source) as Map<String, dynamic>);
}
