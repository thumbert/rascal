import 'dart:io';


_handleGet(HttpRequest request) {
  print("I'm GETing!");
}

_handlePost(HttpRequest request) {
  // when the client runs, I get here.  
  // but how do I display what the client sent?
  print("Inside server Post handling ...");
  print(request.toString());
}

main() {
    
  HttpServer.bind('127.0.0.1', 8080).then((server) {
    server.listen((HttpRequest request) {
//      request.response.write(make_svg("green")); 
//      request.response.close();
      print("Method is " + request.method);
      switch (request.method) {
        case 'GET':
          _handleGet(request);
          break;
          
        case 'POST':
          _handlePost(request);
          break;
          
        default:
          request.response.statusCode = HttpStatus.methodNotAllowed;
      };
      request.response.close();      
    });
  });
  print("Server started");
  
}

