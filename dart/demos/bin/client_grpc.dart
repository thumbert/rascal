//
//import 'package:fixnum/fixnum.dart';
//import 'package:grpc/grpc.dart';
//import 'package:demos/src/generated/timeseries.pbgrpc.dart';
//import 'package:timezone/standalone.dart';
//
//
//main() async {
//  await initializeTimeZone();
//
//  final channel = new ClientChannel('localhost',
//      port: 50051,
//      options: const ChannelOptions(
//          credentials: const ChannelCredentials.insecure()));
//
//  final location = getLocation('US/Eastern');
//
//  final stub = LmpClient(channel);
//
//  var congestion = LmpComponent()..component = LmpComponent_Component.CONGESTION;
//
//  var request = HistoricalLmpRequest()
//    ..ptid = 4000
//    ..start = Int64(TZDateTime(location, 2018).millisecondsSinceEpoch)
//    ..end = Int64(TZDateTime(location, 2019).millisecondsSinceEpoch)
//    ..component = congestion;
//
//  var response = await stub.getLmp(request);
//  print(response);
//
//  await channel.shutdown();
//
//}