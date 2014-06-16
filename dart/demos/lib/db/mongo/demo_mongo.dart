library demo_mongo;

import 'package:mongo_dart/mongo_dart.dart';
 
doAnalysis(e){
  print("working hard");
  print(e);
}
 
main(){
 
  Db db = new Db('mongodb://127.0.0.1/ice');
  db.open().then( (_) {
     print("Connection open");
     DbCollection icegas = db.collection("icecleared_gas");
    
     return icegas.findOne().then((e) {
       print("got one");
       doAnalysis(e);
     });
    
     
   }).then((_) {
     print("Closing the db");
     db.close();
   });
   
}
 