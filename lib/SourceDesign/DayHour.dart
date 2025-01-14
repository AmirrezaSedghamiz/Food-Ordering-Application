// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: constant_identifier_names

import 'package:postgres/postgres.dart';

class DayHour {
  Time startHour;
  Time endHour;
  WeekDay dayOfWeek;
  DayHour({
    required this.startHour,
    required this.endHour,
    required this.dayOfWeek,
  });
}

enum WeekDay { SUNDAY, SATURADY, MONDAY, TUESDAY, WEDNSDAY, THURSDAY, FRIDAY }
