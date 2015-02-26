library sdk_sample;

import 'dart-ext:sample_extension';

/**
 * Play with the sdk examples 
 * http://dart.googlecode.com/svn/trunk/dart/samples/sample_extension/sample_extension.cc
 * 
 */


/**
 * 1) g++ -fPIC -I/home/adrian/dart/dart-sdk -c sample_extension.cc
 * 2) gcc -shared -Wl,-soname,libsample_extension.so -o libsample_extension.so sample_extension.o
 * 3) for fun you can do > objdump -x libsample_extension.so  to check it out
 * 4) you can now run test/ext/example_1/sdk_sample_test.dart
 */


int systemRand() native "SystemRand";

int noScopeSystemRand() native "NoScopeSystemRand";

bool systemSrand(int seed) native "SystemSrand";

