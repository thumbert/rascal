import 'package:more/ordering.dart';

/*
 * Some example of using lists
 */

class Person {
  int age;
  String firstName;
  String lastName;
  
  Person(this.firstName, this.lastName, this.age);
    
  toString() => 
    firstName + " " + lastName + ", " + age.toString(); 
  
}

void sorting() {
  
  List<Person> x = new List<Person>();
  x.add(new Person("Vlady",   "Nabokov", 53));
  x.add(new Person("Dimitri", "Nabokov", 32));
  x.add(new Person("Alice",   "Munroe",  25));
  x.add(new Person("Marcel",  "Proust",  53));
  x.add(new Person("Lev",     "Tolstoy", 87));
  x.add(new Person("Charlie", "Dickens", 47));
  x.add(new Person("Edgar",   "Poe",     37));
  x.forEach((e) => print(e));
  
  int byLastDescending(Person a, Person b) {
    return -a.lastName.compareTo(b.lastName);
  }
  int byAge(Person a, Person b) {
    return a.age.compareTo(b.age);
  }
    
  print("\n\nSort by age!");
  x.sort( byAge );
  x.forEach((e) => print(e));
  
  print("\n\nSort by last name descending!");
  x.sort( byLastDescending );
  x.forEach((e) => print(e));
  
  
  
  print("\n\nSort by age and last name descending!");
  x.sort( (a,b) => byAge(a,b) );
  x.forEach((e) => print(e));
  
  
  
}

/**
 * Using package more!
 */
sorting2() {
  
  // Sort with nulls
  var natural = new Ordering.natural();  
  var ordering = natural.nullsLast();
  print(ordering.sorted([2, null, 3, 1]));

  // explicit sort
  var byMonth = new Ordering.explicit(["Jan", "Feb", "Mar", "Apr"]);
  print(byMonth.sorted(["Feb", "Feb", "Jan", "Apr", "Mar", "Mar"]));
  
  // sort by two variables
  var data = [["BOS", "Jan", 25],
              ["LAX", "Jan", 55],
              ["BOS", "Apr", 54],
              ["BOS", "Feb", 28],
              ["LAX", "Feb", 58]];
  var byCode = natural.onResultOf((obs) => obs[0]);
  print(byCode.sorted(data));
  
  var byCodeMonth = byCode.compound(byMonth.onResultOf((obs) => obs[1]));
  print(byCodeMonth.sorted(data));  // works well and it's readable

}

Map groupBy(Iterable x, Function f) {
  Map result = new Map();
  x.forEach((v) => result.putIfAbsent(f(v), () => []).add(v));
    
  return result;
}


void main() {
  
  // replicate values
  print([1,2,3].expand((e) => new List.filled(5, e)));  
  // (1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3)
  
  // flat map.  Extract the first 2 elements of each sublist
  List<int> links = [[1,3,1], [2,3,4], [3,4,4], [5,3,3]];
  print(links.expand((e) => [e[0], e[1]]));
  
  
  // concatenate two lists. 
  List<int> x = [1, 2, 3];
  List<int> y = [7, 8, 9];
  List<int> z = new List.from(x);
  z.addAll(y.map((e) => -e));
  z.forEach((e)=>print(e));
  
  

  
  
}
