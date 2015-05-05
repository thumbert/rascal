library graphics.axis_datetime_utils;

import 'package:intl/intl.dart';
import 'package:demos/datetime/utils.dart';

enum HeaderType {
  YEAR,
  MONTH,
  DAY,
  HOUR
}

/**
 * Header for a DateTime axis.
 */
class DateTimeAxisHeader {
  HeaderType type;
  DateTime start, end;
  String text;

  static DateFormat ddMMMyy = new DateFormat('dMMMyy');
  static DateFormat MMMyy = new DateFormat('MMMyy');

  DateTimeAxisHeader(DateTime this.start, HeaderType this.type) {
    switch (type) {
      case HeaderType.YEAR:
        assert(isBeginningOfYear(start));
        end = new DateTime(start.year + 1);
        text = start.year.toString();
        break;
      case HeaderType.MONTH:
        assert(isBeginningOfMonth(start));
        end = nextMonth(start);
        text = MMMyy.format(start);
        break;
      case HeaderType.DAY:
        assert(isMidnight(start));
        end = nextDay(start);
        text = ddMMMyy.format(start);
        break;
      default:
        throw('unknown type $type');
    }
  }
}

