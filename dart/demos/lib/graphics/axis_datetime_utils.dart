library graphics.axis_datetime_utils;

import 'package:intl/intl.dart';

bool isMidnight(DateTime datetime) {
  return datetime is DateTime && datetime.millisecond == 0 && datetime.second == 0
  && datetime.minute ==0;
}

bool isBeginningOfMonth(DateTime datetime) => isMidnight(datetime) && datetime.day == 1;

bool isBeginningOfYear(DateTime datetime) => isBeginningOfMonth(datetime) && datetime.month == 1;

enum HeaderType {
  YEAR,
  MONTH,
  DAY,
  HOUR
}

/**
 * Header for a DateTime axis.
 */
class Header {
  HeaderType type;
  DateTime start;
  String text;

  static DateFormat ddMMMyy = new DateFormat('dMMMyy');
  static DateFormat MMMyy = new DateFormat('MMMyy');

  Header(DateTime this.start, HeaderType this.type) {
    switch (type) {
      case HeaderType.YEAR:
        assert(isBeginningOfYear(start));
        text = start.year.toString();
        break;
      case HeaderType.MONTH:
        assert(isBeginningOfMonth(start));
        text = MMMyy.format(start);
        break;
      case HeaderType.DAY:
        assert(isMidnight(start));
        text = ddMMMyy.format(start);
        break;
      default:
        throw('unknown type $type');
    }
  }
}

