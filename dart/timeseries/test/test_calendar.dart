library test_calendar;

import 'package:unittest/unittest.dart';
import 'package:timeseries/time/calendar.dart';
import 'package:timeseries/time/date.dart';

testNercCalendar() {
  /// see http://www.nerc.com/comm/OC/RS%20Agendas%20Highlights%20and%20Minutes%20DL/Additional_Off-peak_Days.pdf
  Calendar cal = new NercCalendar();
  group("Test the NERC Calendar", () {
    test("For 2012", () {
      List days = [new Date(2012,1,2), new Date(2012, 5, 28), new Date(2012,7,4),
      new Date(2012,9,3), new Date(2012,11,22), new Date(2012,12,25)];
      expect(days.map((day) => cal.isHoliday(day)).toList(), new List.filled(6, true));
    });
    test("For 2014", () {
      List days = [new Date(2014,1,1), new Date(2014, 5, 26), new Date(2014,7,4),
        new Date(2014,9,1), new Date(2014,11,27), new Date(2014,12,25)];
      expect(days.map((day) => cal.isHoliday(day)).toList(), new List.filled(6, true));
    });
    test("For 2015", () {
      List days = [new Date(2015,1,1), new Date(2015, 5, 25), new Date(2015,7,4),
        new Date(2015,9,7), new Date(2015,11,26), new Date(2015,12,25)];
      expect(days.map((day) => cal.isHoliday(day)).toList(), new List.filled(6, true));
    });
    test("For 2016", () {
      List days = [new Date(2016,1,1), new Date(2016, 5, 30), new Date(2016,7,4),
      new Date(2016,9,5), new Date(2016,11,24), new Date(2016,12,26)];
      expect(days.map((day) => cal.isHoliday(day)).toList(), new List.filled(6, true));
    });
    test("For 2017", () {
      List days = [new Date(2017,1,2), new Date(2017, 5, 29), new Date(2017,7,4),
      new Date(2017,9,4), new Date(2017,11,23), new Date(2017,12,25)];
      expect(days.map((day) => cal.isHoliday(day)).toList(), new List.filled(6, true));
    });
    test("For 2018", () {
      List days = [new Date(2018,1,1), new Date(2018, 5, 28), new Date(2018,7,4),
      new Date(2018,9,3), new Date(2018,11,22), new Date(2018,12,25)];
      expect(days.map((day) => cal.isHoliday(day)).toList(), new List.filled(6, true));
    });
    test("For 2019", () {
      List days = [new Date(2019,1,1), new Date(2019, 5, 27), new Date(2019,7,4),
      new Date(2019,9,2), new Date(2019,11,28), new Date(2019,12,25)];
      expect(days.map((day) => cal.isHoliday(day)).toList(), new List.filled(6, true));
    });
    test("For 2020", () {
      List days = [new Date(2020,1,1), new Date(2020, 5, 25), new Date(2020,7,4),
      new Date(2020,9,7), new Date(2020,11,26), new Date(2020,12,25)];
      expect(days.map((day) => cal.isHoliday(day)).toList(), new List.filled(6, true));
    });
    test("For 2021", () {
      List days = [new Date(2021,1,1), new Date(2021, 5, 31), new Date(2021,7,5),
      new Date(2021,9,6), new Date(2021,11,25), new Date(2021,12,25)];
      expect(days.map((day) => cal.isHoliday(day)).toList(), new List.filled(6, true));
    });
    test("For 2022", () {
      List days = [new Date(2022,1,1), new Date(2022, 5, 30), new Date(2022,7,4),
      new Date(2022,9,5), new Date(2022,11,24), new Date(2022,12,26)];
      expect(days.map((day) => cal.isHoliday(day)).toList(), new List.filled(6, true));
    });
    test("For 2023", () {
      List days = [new Date(2023,1,2), new Date(2023, 5, 29), new Date(2023,7,4),
      new Date(2023,9,4), new Date(2023,11,23), new Date(2023,12,25)];
      expect(days.map((day) => cal.isHoliday(day)).toList(), new List.filled(6, true));
    });
    test("For 2024", () {
      List days = [new Date(2024,1,1), new Date(2024, 5, 27), new Date(2024,7,4),
      new Date(2024,9,2), new Date(2024,11,28), new Date(2024,12,25)];
      expect(days.map((day) => cal.isHoliday(day)).toList(), new List.filled(6, true));
    });
    test("For 2025", () {
      List days = [new Date(2025,1,1), new Date(2025, 5, 26), new Date(2025,7,4),
      new Date(2025,9,1), new Date(2025,11,27), new Date(2025,12,25)];
      expect(days.map((day) => cal.isHoliday(day)).toList(), new List.filled(6, true));
    });
  });



}

main() => testNercCalendar();