library mongo.nepool_dalmp;

import 'dart:io';
import 'dart:async';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:intl/intl.dart';
//import 'package:congviewer/utils.dart';

Future with_db(Db db, Function callback) {
  return db.open().then((_) {
    return callback();
  }).then((_) => db.close());
}


/**
 * +0400 for EDT, +0500 for EST
 * db.DA_LMP.find({ptid: 321, hourBeginning: {$lte: ISODate('2014-11-03T04:00:00Z')}})
 * db.DA_LMP.find({ptid: 321, hourBeginning: {$gte: ISODate('2014-11-05T05:00:00Z')}}).limit(5)
 *
 *
 */
class DaLmp {

  Db db;
  DbCollection coll;
  String DIR = 'S:/All/Structured Risk/NEPOOL/FTRs/ISODatabase/NEPOOL/LMP/DA/Raw/';
  final DateFormat fmt = new DateFormat("yyyy-MM-ddTHH:00:00.000-ZZZZ");

  DaLmp({this.db}) {
    if (db == null)
      db = new Db('mongodb://127.0.0.1/nepool_dam');

    coll = db.collection('DA_LMP');
  }

  /**
   * Get the low and high limit for the data to define the yScale for plotting.
   * [start] a day in the yyyy-mm-dd format, e.g. '2015-01-01',
   * [end] a day in the yyyy-mm-dd format, e.g. '2015-01-09'.  This is inclusive of end date.
   * db.DA_LMP.aggregate([{$match: {ptid: {$in: [4001, 4000]}}},
   *   {$group: {_id: null, yMin: {$min: '$congestionComponent'}, yMax: {$max: '$congestionComponent'}}}])
   */
  Future<Map> getLimits(List<int> ptids, String start, String end, {String frequency: 'hourly'}) {
    List pipeline = [];
    var groupId;
    Map group;
//    String startDate = new DateFormat('yyyy-MM-dd').format(start);
//    String endDate = new DateFormat('yyyy-MM-dd').format(end);

    var match = {
      '\$match': _constructMatchClause(ptids, start, end)
    };

    if (frequency == 'daily') {
      groupId = {
        'ptid': '\$ptid',
        'year': {
          '\$year': '\$hourBeginning'
        },
        'month': {
          '\$month': '\$hourBeginning'
        },
        'day': {
          '\$dayOfMonth': '\$hourBeginning'
        }
      };

    } else if (frequency == 'monthly') {
      groupId = {
        'ptid': '\$ptid',
        'year': {
          '\$year': '\$hourBeginning'
        },
        'month': {
          '\$month': '\$hourBeginning'
        }
      };
    }

    if (frequency != 'hourly') {
      // i need to average it first
      group = {
        '\$group': {
          '_id': groupId,
          'congestionComponent': {
            '\$avg': '\$congestionComponent'
          }
        }
      };
    } else {
      // for hourly data calculate the min and max directly
      group = {
        '\$group': {
          '_id': null,
          'yMin': {
            '\$min': '\$congestionComponent'
          },
          'yMax': {
            '\$max': '\$congestionComponent'
          }
        }
      };
    }
    ;

    pipeline.add(match);
    pipeline.add(group);

    if (frequency != 'hourly') {
      // i need to aggregate further (the days or the months)
      var group2 = {
        '\$group': {
          '_id': null,
          'yMin': {
            '\$min': '\$congestionComponent'
          },
          'yMax': {
            '\$max': '\$congestionComponent'
          }
        }
      };
      pipeline.add(group2);
    }

    ///print(pipeline);
    return coll.aggregate(pipeline).then((v) {
      ///print(v['result']);
      return v['result'].first;
    });


  }


  /**
   * Get the hourly congestion data from the table,
   * from [start, end) DateTime.   Note that end is exclusive!
   * Try to to get too much data at once (Should I worry about this here?!).
   * db.DA_LMP.find({ptid: {$in: [321, 4000]}}, {_id: 0}).limit(10)
   * TODO: does the result need to be ordered by ptid and hourBeginning?  Don't think so...
   */
  Future<List<Map>> getHourlyCongestionData(List<int> ptids, DateTime start, DateTime end) {
    assert(start.isUtc);
    assert(end.isUtc);
    SelectorBuilder sb = where;

    if (ptids != null && ptids.isNotEmpty)
      sb = sb.oneFrom('ptid', ptids);

    // if you want to pull all the ptids at once, better to be a bit careful ...
    if (start != null)
      sb = sb.gte('hourBeginning', start);

    if (end != null)
      sb = sb.lt('hourBeginning', end);

    //print(sb.toString());
    return coll.find(sb.excludeFields(['_id']).sortBy('ptid').sortBy('hourBeginning')).toList();
    //return coll.find(sb.excludeFields(['_id'])).toList();
  }


  /**
   * Aggregate the hourly data daily between start and end dates inclusive.
   * [start] a day in the yyyy-mm-dd format, e.g. '2015-01-01'
   * [end] a day in the yyyy-mm-dd format, e.g. '2015-01-09'
   *
   *
   * db.DA_LMP.aggregate([{$match: {ptid: {$in: [321, 4000]}}}, {$group: {_id: {ptid: {$ptid}, localDate: {$localDate}}, congestionComponent: {$avg: '$congestionComponent'}}}])
   */
  Future<List<Map>> getDailyCongestionData(List<int> ptids, String start, String end) {
    assert(start.compareTo(end) < 1);
    List pipeline = [];
    var match = {
      '\$match': _constructMatchClause(ptids, start, end)
    };
    var group = {
      '\$group': {
        '_id': {
          'ptid': '\$ptid',
          'localDate': '\$localDate'
        },
        'congestionComponent': {
          '\$avg': '\$congestionComponent'
        }
      }
    };
    var sort = {
      '\$sort': {
        '_id.ptid': 1,
        '_id.localDate': 1
      }
    };
    pipeline.add(match);
    pipeline.add(group);
    pipeline.add(sort);
    //print(pipeline);
    return coll.aggregate(pipeline).then((v) {
      //print(v['result']);
      return v['result'].map((Map doc) {
        return {
          'date': DateTime.parse('${doc['_id']['localDate']}'),
          'ptid': doc['_id']['ptid'],
          'congestionComponent': doc['congestionComponent']
        };
      }).toList();
    });
    // {date: DateTime(2014,12,26), ptid: 321, congestionComponent: 4.381666666666667}
    // {date: DateTime(2014,12,27), ptid: 321, congestionComponent: 11.077083333333334}
  }


  /**
   * Aggregate data monthly between the months start and end inclusive.
   * start a String representing a date in yyyy-mm-dd format, beginning of the month
   * end a String representing a date in yyyy-mm-dd format, beginning of the month
   * Result looks like this:
   * [{month: DateTime(2014,1), ptid: 4005, congestionComponent: 1.1392876344086023},
   * {month: DateTime(2014,2), ptid: 4005, congestionComponent: 0.6015029761904762}
   * {month: DateTime(2014,3), ptid: 4005, congestionComponent: 0.8584656796769845}
   * {month: DateTime(2014,4), ptid: 4005, congestionComponent: -0.09127777777777786}]
   * db.DA_LMP.aggregate([{$match: {ptid: {$in: [321]}, localDate: {$gte: '2014-12-01', $lte: '2014-12-01'}}}, {$project: {congestionComponent: 1, ptid: 1, month: {$substr: ['$localDate', 0, 7]}}},
      {$group: {}}])
   */
  Future<List<Map>> getMonthlyCongestionData(List<int> ptids, String start, String end) {
    assert(start.substring(7) == '-01');
    assert(end.substring(7) == '-01');
    assert(start.compareTo(end) < 1);
    var startDate = start;
    // go to the end of month for the end Date
    var aux = nextMonth(from: DateTime.parse(end)).subtract(new Duration(days: 1));
    var endDate = new DateFormat('yyyy-MM-dd').format(aux);

    List pipeline = [];

    var match = {
      '\$match': _constructMatchClause(ptids, startDate, endDate)
    };
    var project = {
      '\$project': {
        'congestionComponent': 1,
        'ptid': 1,
        'month': {'\$substr': ['\$localDate', 0, 7]}
      }
    };
    var group = {
      '\$group': {
        '_id': {
          'ptid': '\$ptid',
          'month': '\$month'
        },
        'congestionComponent': {
          '\$avg': '\$congestionComponent'
        }
      }
    };
    var sort = {
      '\$sort': {
        '_id.ptid': 1,
        '_id.month': 1
      }
    };
    pipeline.add(match);
    pipeline.add(project);
    pipeline.add(group);
    pipeline.add(sort);
    //print(pipeline);
    return coll.aggregate(pipeline).then((v) {
      //print(v['result']);
      return v['result'].map((Map doc) {
        return {
          'month': DateTime.parse('${doc['_id']['month']}-01'),
          'ptid': doc['_id']['ptid'],
          'congestionComponent': doc['congestionComponent']
        };
      }).toList();
    });
  }


  /**
   * Format the return of getData from the long format to the wide format (to minimize
   * the amount of data transferred).  Hourly data is in hourBeginning format
   * [frequency] is one of 'hourly', 'daily', 'monthly'.
   * Argument data is in format:
   *  [{'hourBeginning': x, 'ptid': x, 'congestionComponent': x},
   *   {'hourBeginning': x, 'ptid': x, 'congestionComponent': x}]
   * Output is in format:
   *    {'321': {'DT': [dt1, dt2, ...], 'CC': [c1, c2, ...]}},
   *     '322': {'DT': [dt1, dt2, ...], 'CC': [c1, c2, ...]}},
   *    ...}
   * where dt1, dt2, etc. are int millisecondsSinceEpoch
   */
  Map<String, Map> toWideFormat(List<Map> data, String frequency) {
    // need to traverse twice ... // TODO explore if you do this in one pass ...
    Map idFreq = {'hourly': 'hourBeginning', 'daily': 'date', 'monthly': 'month'};
    String id = idFreq[frequency];

    // group all rows by ptid
    Map<String, List> gData = {
    };
    data.forEach((row) => gData.putIfAbsent(row['ptid'].toString(), () => []).add(row));

    Map<String, Map> res = {
    };
    gData.keys.forEach((String key) => res[key] = {
      'DT': [], 'CC': []
    });
    for (String key in gData.keys) {
      //print('Transposing $key ...');
      gData[key].forEach((row) {
        res[key]['DT'].add(row[id].millisecondsSinceEpoch);
        res[key]['CC'].add(row['congestionComponent']);
      });
    }


    return res;
  }

  /**
   * Bring the db up to date.
   * Find the latest day in the archive and update from there to nextDay
   * [from] is a midnight UTC day
   */
  updateDb({DateTime from}) {
    return db.open()
    .then((_) => lastDayInserted()
    .then((DateTime lastDay) {
      DateTime start, end;
      if (from == null)
        start = new DateTime.utc(lastDay.year, lastDay.month, lastDay.day).add(new Duration(days: 1));
      else
        start = from;
      DateTime now = new DateTime.now();
      if (now.hour < 14)
        end = new DateTime.utc(now.year, now.month, now.day);
      else
        end = nextDay().toUtc();
      print('Updating the db from $start to $end.');
      return insertDaysStartEnd(start, end);
    }))
    .then((_) => db.close());
  }


  /**
   * Archive and Insert days between start, end.
   * Parameters start and end are midnight UTC DateTime objects.
   * For each day in the range of days, download and insert the data into the db.
   */
  insertDaysStartEnd(DateTime start, DateTime end) {
    List<DateTime> days = seqDays(start, end);
    DateFormat fmtDay = new DateFormat('yyyyMMdd');

    return Future.forEach(days, (day) {
      String yyyymmdd = fmtDay.format(day);
      return oneDayDownload(yyyymmdd).then((_) {
        return oneDayMongoInsert(yyyymmdd);
      });
    }).then((_) {
      print('Done!');
    });

  }

  /**
   * Make the daily insertions idempotent, so you never insert the same data over
   * and over again.  You should run this only once when you set up the database.
   * db.DA_LMP.ensureIndex({hourBeginning: 1, ptid: 1}, {unique: true})
   * db.DA_LMP.getIndexes()
   */
  prepareCollection() {
    return db.open().then((_) {
      return db.ensureIndex('DA_LMP', keys: {
        'ptid': 1, 'hourBeginning': 1
      }, unique: true);
    }).then((_) {
      db.close();
    });
  }

  /**
   * Return the last day that was ingested in the db.
   * db.DA_LMP.aggregate([{$group: {_id: null, firstHour: {$min: '$hourBeginning'}, lastHour: {$max: '$hourBeginning'}}}])
   */
  Future<DateTime> lastDayInserted() {
    DateTime lastDay;

    List pipeline = [];
    var group = {
      '\$group': {
        '_id': null, 'last': {
          '\$max': '\$hourBeginning'
        }
      }
    };
    pipeline.add(group);
    return coll.aggregate(pipeline).then((v) {
      print('$v');
      Map aux = v['result'].first;
      lastDay = aux['last']; // a local datetime
      return new DateTime.utc(lastDay.year, lastDay.month, lastDay.day);
    });
  }

  /**
   * Inserts one day into the db.
   */
  Future oneDayMongoInsert(String yyyymmdd) {
    List data = oneDayCsvRead(yyyymmdd);
    if (data.isEmpty)
      return new Future.value(print('No data for $yyyymmdd.  Skipping.'));

    DbCollection coll = db.collection('DA_LMP');
    print('Inserting $yyyymmdd into db');
    return coll.insertAll(data)
    .then((_) => print('--->  SUCCESS'))
    .catchError((e) => print(e));
  }

  /**
   * Read the csv file and prepare it for ingestion into mongo.
   * DateTimes need to be hourBeginning UTC, etc.
   */
  List<Map> oneDayCsvRead(String yyyymmdd) {
    List<Map> data = [];
    File file = new File(DIR + "WW_DALMP_ISO_${yyyymmdd}.csv");

    List<String> keys = ['hourBeginning', 'localDate', 'ptid', 'congestionComponent'];

    data = file.readAsLinesSync()
    .map((String row) => row.split(','))
    .where((List row) => row.first == '"D"')
    //.where((List row) => row[3] == '"321"')
    .map((List row) {
      return new Map.fromIterables(keys, [
        parseIsoTimestamp(unquote(row[1]), unquote(row[2]), hourEnding: false),
        to_yyyymmdd(unquote(row[1])),
        int.parse(unquote(row[3])),
        num.parse(row[8])
      ]);
    }).toList();


    //data.forEach((e) => print(e));

    return data;
  }

  Future oneDayDownload(String yyyymmdd) {
    String URL = "http://www.iso-ne.com/static-transform/csv/histRpts/da-lmp/WW_DALMP_ISO_$yyyymmdd.csv";
    File file = new File(DIR + "WW_DALMP_ISO_${yyyymmdd}.csv");
    if (file.existsSync()) {
      print('  file already downloaded');
      return new Future.value([0]);
    } else {
      print('  downloading file');
      return new HttpClient().getUrl(Uri.parse(URL))
      .then((HttpClientRequest request) => request.close())
      .then((HttpClientResponse response) =>
      response.pipe(file.openWrite()));
    }
  }

  /**
   * For the pipeline aggregation queries
   * start and end are Strings in yyyy-mm-dd format.
   */
  Map _constructMatchClause(List<int> ptids, String start, String end) {
    Map aux = {
    };
    if (ptids != null)
      aux['ptid'] = {
        '\$in': ptids
      };
    if (start != null) {
      if (!aux.containsKey('localDate'))
        aux['localDate'] = {
        };

      aux['localDate']['\$gte'] = start;
    }
    if (end != null) {
      if (!aux.containsKey('localDate'))
        aux['localDate'] = {
        };

      aux['localDate']['\$lte'] = end;
    }


    return aux;
  }


}

