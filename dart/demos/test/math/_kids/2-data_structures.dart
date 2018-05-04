main() {
  String x = 'Say hello to: ';
  String y = 'Lara';
  print(x);
  print(y);

  List names = ['Jessi', 'penelope',  'Adrian', 'teresa'];
  print(names);
  List lastnames = ['Khol','shrauder','Thunderbolt', 'hunderfunk'];
  List phonenumbers = ['340-3459', '678-890', '410-440', '123-1234'];
  print(x + names[0]);
  print(x + names[1]);
  print(x + names[2]);

  print('\n===============================================\n');
  for (var name in names) {
    print(x + name);
  }
  print('\n===============================================\n');
  for (String name in names) {
    print(x + name.toUpperCase());
  }

  print('\n===============================================\n');
  for (int i=0; i<names.length; i++) {
    print('i=' + i.toString());
    print(x + names[i] + ' ' + lastnames[i]);
    print('phone number: ' + phonenumbers[i]);
  }

  print(names.contains('Adrian'));
  print(names.contains('mimi'));

  var ind = names.indexOf('Adrian');
  print('Adrian -> ' + phonenumbers[ind]);


  print('\n===============================================\n');
  Map age = {
    'Lara': 13,
    'Adrian': 44,
    'Cassie': 11,
    'Anda': 41,
  };

  print(age['Anda']);

  Map phone = new Map.fromIterables(names, phonenumbers);
  Map phone2 = new Map.fromIterables(phonenumbers, names);
  print(phone['teresa']);
  print(phone2['410-440']);
  print(phone.keys);
  print(phone.values);




}
