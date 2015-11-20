import 'dart:io';

/**
 * Send an SVG to a server
 */

String make_svg(String color) {
  
  String svg = """
      <!DOCTYPE html>
      <html>
      <body>
      
      <svg height="100" width="100">
        <circle cx="50" cy="50" r="40" stroke="black" stroke-width="3" fill="$color" />
      Sorry, your browser does not support inline SVG.  
      </svg> 
      
      </body>
      </html>""";
  
  return svg;
}

send_svg() {
  HttpClient client = new HttpClient();
  client.open('POST','127.0.0.1', 8080, "")
    .then((HttpClientRequest request) {
      print("Here!");
      request.write( make_svg("blue") );
      return request.close();
    });   
}

main(){
  
  send_svg();
  
  print("Done!");
}