// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'package:data_base_project/DataHandler/QueryHandler.dart';

import 'package:postgres/postgres.dart';

class DayHour {
  String startHour;
  String endHour;
  WeekDay dayOfWeek;
  DayHour({
    required this.startHour,
    required this.endHour,
    required this.dayOfWeek,
  });

  factory DayHour.fromMap(Map<String, dynamic> map) {
    List<WeekDay> weekDay = [
      WeekDay.SUNDAY,
      WeekDay.SATURADY,
      WeekDay.MONDAY,
      WeekDay.TUESDAY,
      WeekDay.WEDNSDAY,
      WeekDay.THURSDAY,
      WeekDay.FRIDAY
    ];
    return DayHour(
      startHour: map['starthour'],
      endHour: map['endhour'],
      dayOfWeek: weekDay[map['dayofweek'] - 1],
    );
  }

  factory DayHour.fromJson(String source) =>
      DayHour.fromMap(json.decode(source) as Map<String, dynamic>);

  static Future<List<DayHour>?> getDayHours({required int restaurantId}) async {
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
              'SELECT get_working_hours_by_restaurant(@input_restaurant_id)'),
          parameters: {
            'input_restaurant_id': restaurantId,
          });
      dynamic finalRes = result[0][0];
      List<DayHour> values = [];
      for (var i in finalRes) {
        values.add(DayHour.fromMap(i));
      }
      return values;
    } catch (e) {
      print('Error: $e');
    } finally {
      await connection.close();
    }
    return null;
  }

  static Future<void> upsertDayHours({
    required String startTime,
    required String endTime,
    required int dayOfWeek,
    required int restaurantId,
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
              'CALL upsert_dayhours(@restaurantid_param , @dayofweek_param , @starthour , @endhour)'),
          parameters: {
            'restaurantid_param': restaurantId,
            'dayofweek_param': dayOfWeek,
            'starthour': startTime,
            'endhour': endTime,
          });
    } catch (e) {
      print('Error: $e');
    } finally {
      await connection.close();
    }
  }

  static Future<void> deleteDayHours({required int restaurantId}) async {
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
          Sql.named('CALL delete_dayhours(@restaurantid_param)'),
          parameters: {
            'restaurantid_param': restaurantId,
          });
    } catch (e) {
      print('Error: $e');
    } finally {
      await connection.close();
    }
  }

  @override
  String toString() =>
      'DayHour(startHour: $startHour, endHour: $endHour, dayOfWeek: $dayOfWeek)';
}

enum WeekDay { SUNDAY, SATURADY, MONDAY, TUESDAY, WEDNSDAY, THURSDAY, FRIDAY }
