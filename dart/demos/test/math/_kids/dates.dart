

main() {
  var bd = DateTime(2019, 10, 5);
  var dt = DateTime.now();
  var ct = DateTime(2018, 12, 24);
  print(dt);
  print('HOURS UNTIL MY BDAY!');
  print(bd.difference(dt).inHours);
  print ('HOURS UNTIL CHRISTMAS!');

  print(ct.difference(dt).inHours);
























}