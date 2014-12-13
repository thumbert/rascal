library test_seq;

import 'package:unittest/unittest.dart';
import 'package:timeseries/seq.dart';

test_seq() {
  
  group('sequence tests: ', () {
  
    test('an integer range', () {
      expect(seqInt(0, 10, 2), [0, 2, 4, 6, 8, 10]);
    }); 
  
    test('a day range', () {
      expect(seqDay(new DateTime(2013,1), new DateTime(2013,1,10), 4), 
        [new DateTime(2013,1,1), new DateTime(2013,1,5), new DateTime(2013,1,9)]);
    }); 
  
    test('a monthly range', () {
      expect(seqMonth(new DateTime(2013,1), new DateTime(2014,3), 4), 
        [new DateTime(2013,1), new DateTime(2013,5), new DateTime(2013,9), new DateTime(2014,1)]);
    });
  
  });
}
