library test_lists;

import 'dart:collection';
import 'dart:math' show min;

class Person {
  String name;
  int age;
  Person(this.name, this.age);
  String toString() => "{name: $name, age: $age}";
}

class MyCustomList<E> extends Object with ListMixin<E> {
  final List<E> l = [];
  MyCustomList();

  void set length(int newLength) { l.length = newLength; }
  int get length => l.length;
  E operator [](int index) => l[index];
  void operator []=(int index, E value) { l[index] = value; }

}



main() {
  List x = [new Person("Andrei", 50),
            new Person("Laura",  10), 
            new Person("Gaga",   27)];
  
  x.removeWhere((p) => p.age < 20);
  print(x);
  
  MyCustomList y = new MyCustomList();
  y.addAll([new Person("Andrei", 50),
            new Person("Laura",  10), 
            new Person("Gaga",   27)]);
  y.removeWhere((p) => p.age < 20);
  print(y);

  /// Calculate the minimum of a list
  List z = [3, 5, 1, 4, 7];
  print(z.fold(z.first, (a,b) => min(a,b)));

}