library test_csv;

import 'package:csv/csv.dart';

var seatac = """"month","day","year","max.temp","record.max","normal.max","min.temp","record.min","normal.min","precip","record.precip","normal.precip","time.max","time.min"
"January",1,2007,43,58,45,34,10,35,0.13,1.37,0.17,1509,13
"January",2,2007,56,56,45,45,6,35,1.77,1.51,0.17,1000,135
"January",3,2007,48,58,45,43,6,35,1.01,1.01,0.17,1411,713
"January",4,2007,42,61,45,37,14,36,0.06,1.56,0.17,1535,1732
"January",5,2007,43,55,45,31,15,36,0.19,1.33,0.17,1312,55
"January",6,2007,44,57,45,36,14,36,NA,1.22,0.17,23,809
"January",7,2007,49,59,45,40,19,36,0.93,1.33,0.17,1544,127
"January",8,2007,47,54,45,38,18,36,0,1.13,0.17,1659,659
"January",9,2007,51,56,45,41,13,36,0.16,2.83,0.17,1415,1659
"January",10,2007,36,59,45,32,12,36,0.01,0.94,0.17,1558,607
"January",11,2007,31,59,45,27,12,36,0,1.26,0.17,1401,724
"January",12,2007,31,59,45,19,13,36,NA,1.3,0.17,1523,842
"January",13,2007,29,56,45,21,11,36,0,1.63,0.17,1658,605
"January",14,2007,35,59,45,20,8,36,NA,1.61,0.17,1453,803
"January",15,2007,35,58,46,23,15,36,NA,1.68,0.17,1443,934
"January",16,2007,35,54,46,28,13,36,0.18,1.78,0.17,1632,619
"January",17,2007,39,55,46,33,15,36,NA,2.39,0.17,1349,850
"January",18,2007,42,60,46,34,9,36,0.16,2.98,0.16,1659,434
"January",19,2007,42,62,46,38,18,36,0.08,2.26,0.16,1659,936
"January",20,2007,45,64,46,37,16,36,NA,1.66,0.16,1549,703
"January",21,2007,42,62,46,37,13,36,NA,1.64,0.16,1659,827
"January",22,2007,50,60,46,40,19,36,0,1.29,0.16,1617,147
"January",23,2007,52,56,46,44,16,36,0,1.36,0.16,1553,559
"January",24,2007,51,58,47,35,10,36,NA,1.36,0.16,1328,752
"January",25,2007,43,58,47,33,7,36,0.02,0.93,0.16,1602,744
"January",26,2007,44,58,47,37,9,36,NA,1.03,0.16,1558,1058
"January",27,2007,52,58,47,32,11,36,NA,1.61,0.16,1419,840
"January",28,2007,50,57,47,28,7,36,NA,1.23,0.16,1436,711
"January",29,2007,40,60,47,28,6,36,NA,1.63,0.16,1618,542
"January",30,2007,48,59,47,33,7,36,NA,1,0.16,1618,715
"January",31,2007,48,61,47,28,0,36,NA,1.93,0.16,1529,638
"February",1,2007,49,63,48,30,1,36,NA,1.34,0.16,1619,523
"February",2,2007,44,64,48,28,8,37,NA,1.32,0.16,1325,529
"February",3,2007,42,63,48,31,8,37,0.12,1.29,0.16,1056,301
"February",4,2007,54,63,48,41,7,37,0.16,0.91,0.16,1456,601
"February",5,2007,45,62,48,42,14,37,NA,0.96,0.16,1434,1013
"February",6,2007,48,64,48,41,18,37,0.03,1.54,0.16,1646,939
"February",7,2007,51,66,49,43,20,37,0,2.58,0.15,1659,525
"February",8,2007,53,68,49,42,22,37,0.01,3.06,0.15,1349,701
"February",9,2007,57,62,49,42,26,37,0.08,2.98,0.15,1553,639
"February",10,2007,56,65,49,42,24,37,NA,0.96,0.15,1424,607
"February",11,2007,54,62,49,45,27,37,0.11,0.81,0.15,1434,851
"February",12,2007,53,66,49,42,21,37,0,1.23,0.15,1356,727
"February",13,2007,51,59,49,41,18,37,0.02,1.4,0.15,1617,711
"February",14,2007,46,63,49,40,22,37,0.15,0.74,0.15,1122,128
"February",15,2007,53,65,50,46,13,37,0.12,0.94,0.15,1501,600
"February",16,2007,51,58,50,43,13,37,0.01,1.83,0.15,1520,725
"February",17,2007,58,58,50,44,23,37,NA,0.65,0.15,1436,732
"February",18,2007,46,62,50,41,20,37,NA,1.63,0.15,1357,740
"February",19,2007,46,67,50,41,22,37,0.17,1.76,0.15,1553,237
"February",20,2007,44,62,50,37,25,37,0.25,0.74,0.15,41,1412
"February",21,2007,50,67,50,34,25,37,0.02,0.97,0.14,1528,610
"February",22,2007,48,64,50,37,30,38,0.13,0.71,0.14,1513,718
"February",23,2007,44,61,51,35,28,38,0.01,1.16,0.14,1552,809
"February",24,2007,44,62,51,36,25,38,0.36,1.55,0.14,1510,633
"February",25,2007,45,64,51,39,22,38,0.15,0.8,0.14,1659,231
"February",26,2007,47,67,51,38,18,38,0.03,1.19,0.14,1410,839
"February",27,2007,42,70,51,31,20,38,0,2.23,0.14,1619,709
"February",28,2007,41,68,51,34,24,38,0.04,1.46,0.14,1445,839
"March",1,2007,41,62,51,31,23,38,0,0.84,0.14,1238,733
"March",2,2007,43,64,51,32,22,38,0.08,1.16,0.14,1630,256
"March",3,2007,52,69,52,41,20,38,0.05,2.08,0.13,1659,252
"March",4,2007,55,68,52,41,11,38,NA,0.92,0.13,1633,636
"March",5,2007,59,66,52,46,13,38,0.06,2.7,0.13,1659,708
"March",6,2007,68,64,52,41,26,38,NA,1.18,0.13,1412,654
"March",7,2007,54,66,52,47,26,38,0.14,0.67,0.13,0,1251
"March",8,2007,50,67,52,42,28,39,0.16,1.01,0.13,1232,750
"March",9,2007,53,67,52,43,28,39,0.03,0.83,0.13,1259,601
"March",10,2007,57,68,52,47,20,39,0.08,0.87,0.13,1311,736
"March",11,2007,NA,65,52,NA,23,39,0.42,1.01,0.13,NA,NA
"March",12,2007,53,68,53,46,25,39,0.1,0.99,0.13,30,709
"March",13,2007,49,70,53,36,28,39,0,0.7,0.12,1336,653
"March",14,2007,48,64,53,38,26,39,NA,0.76,0.12,1547,708
"March",15,2007,47,61,53,34,30,39,0,1.2,0.12,1410,457
"March",16,2007,66,66,53,42,29,39,0,0.98,0.12,1545,107
"March",17,2007,52,65,53,47,27,39,0.09,1.05,0.12,1542,740
"March",18,2007,61,70,53,48,29,39,0.02,1.86,0.12,1603,729
"March",19,2007,51,63,54,48,27,39,0.25,1.27,0.12,1311,1659
"March",20,2007,50,69,54,40,26,39,0.1,0.76,0.12,1256,1449
"March",21,2007,51,69,54,32,29,39,NA,0.82,0.12,1437,542
"March",22,2007,51,68,54,44,28,40,0.07,1.81,0.11,1105,111
"March",23,2007,51,68,54,46,28,40,0.09,0.94,0.11,1659,638
"March",24,2007,53,66,54,50,30,40,0.85,0.98,0.11,114,1659
"March",25,2007,54,64,54,43,31,40,0.01,0.51,0.11,1608,752
"March",26,2007,59,70,55,36,32,40,NA,1.51,0.11,1419,535
"March",27,2007,50,71,55,41,26,40,0.24,0.64,0.11,1456,643
"March",28,2007,54,73,55,37,26,40,NA,0.53,0.11,1421,633
"March",29,2007,63,78,55,37,24,40,NA,0.7,0.11,1410,553
"March",30,2007,53,72,55,44,27,40,0.06,0.65,0.11,1121,232
"March",31,2007,50,75,55,41,30,40,0.18,0.57,0.1,1348,806""";

Function toNumeric = (String x) {
  if (x == "" || x == "NA")
    return null;
  else  
    return num.parse(x);
  };
Function I = (x) => x;


main() {
  final csvCodec = new CsvCodec();
  final decoder = csvCodec.decoder;
  
  var y = decoder.convert('1,,3');
  print(y);
  if (y[0][1] == "") {
    print("You're right, the second element is the empty string!");
  }
  
  List<List<String>> x = decoder.convert(seatac);
  //print(x);

  var z = decoder.convert('"March",29,NA,553', 
      parseNumbers: false);
  var res = z.map((e)=>[I(e[0])].addAll(e.sublist(1).map((x) => toNumeric(x)))); // addAll returns void!
  print(res);
  
  
  
}