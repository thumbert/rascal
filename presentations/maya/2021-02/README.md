# maya presentation 2021-02
with remark 13.0.0

To present, you need to serve /index.html with a webserver.  Assuming you have 
Dart installed in path, you can do:

```
pub global activate dhttpd 
pub global run dhttpd --port=9001
```

This will serve the /index.html file on localhost:9001

See https://github.com/gnab/remark/wiki for details on how to use remark.
