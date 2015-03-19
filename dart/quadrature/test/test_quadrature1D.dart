library test_quadrature1D;

//import 'package:quadrature/src/incrementor.dart';
import 'package:unittest/unittest.dart';
import 'package:quadrature/trapezoid_integrator.dart';
import 'package:quadrature/simpson_integrator.dart';
import 'package:quadrature/tanhsinh_integrator.dart';
import 'dart:math';
import 'package:quadrature/gausslegendre_integrator.dart';
import 'package:logging/logging.dart';
import 'package:logging_handlers/logging_handlers_shared.dart' as loghandlers;
import 'package:quadrature/filon_integrator.dart';

/*
 * Round a double to a certain digit. 
 * e.g. round(1.23456, 2) == 1.23
 * 
 */
double round(double value, [int digit=1]) {
  if (value.isFinite) {
    double pow10 = pow(10.0, digit);
    return (pow10*value).round()/pow10;
  } else {
    return value;
  } 
}



main() {
  
  Logger.root.onRecord.listen(new loghandlers.LogPrintHandler());
  Logger.root.level = Level.FINE; // FINER, FINEST, CONFIG 
  //Logger.root.level = Level.INFO;  
  //Logger.root.level = Level.WARNING; 

  
  /* 
   * Test problems from 
   * http://projecteuclid.org/download/pdf_1/euclid.em/1128371757
   * The following 15 integrals were used as a test suite to 
   * compare these three quadrature schemes. In each case
   * an analytic result is known, as shown below, facilitating
   * the checking of results. The 15 integrals are listed in five
   * groups:
   *   1–4: continuous, well-behaved functions (all deriva-
   *     tives exist and are bounded) on finite intervals;
   *   5–6: continuous functions on finite intervals, but
   *     with an infinite derivative at an endpoint;
   *  7–10: functions on finite intervals with an integrable
   *     singularity at an endpoint;
   *  11–13: functions on an infinite interval;
   *  14–15: oscillatory functions on an infinite interval.
   * 
   */

  group("TanhSinh integrator", () {
    TanhSinhIntegrator quad = new TanhSinhIntegrator();
    test(r"\int_0^1 x \log(1+x) dx = 0.25", () {
      num r = quad.integrate(10000000, (x) => x*log(1+x), 0.0, 1.0);
      expect(round(r, 2), 0.25);     
    }); 
    test(r"\int_0^1 x^2 \arctan(x) dx = (pi - 2 + 2log2)/12", () {
      num r = quad.integrate(10000000, (x) => pow(x,2)*atan(x), 0.0, 1.0);
      num i = (PI - 2 + 2*log(2))/12;
      expect(round(r, 6), round(i,6)); 
    });
    test(r"\int_0^{\pi/2} \exp(x)\cos(x) dx = (e^{\pi/2} - 1)/2", () {
      num r = quad.integrate(100000, (x) => exp(x)*cos(x), 0.0, PI/2);
      num i = 0.5*(exp(PI/2)-1);
      expect(round(r, 5), round(i,5)); 
    });
    test(r"\int_0^1 \frac{\arctan(\sqrt{2+x^2})}{(1+x^2)\sqrt{2+x^2}} dx = 5\pi^2/96", () {
      num r = quad.integrate(100000, (x) => atan(sqrt(2+x*x))/((1+x*x)*sqrt(2+x*x)), 0.0, 1.0);
      num i = 5*PI*PI/96;
      expect(round(r, 6), round(i,6)); 
    });
    test(r"\int_0^1 \sqrt{x}\log(x)) dx = -4/9", () {
      num r = quad.integrate(100000, (x) => sqrt(x)*log(x), 0.0, 1.0);
      num i = -4.0/9;
      expect(round(r, 5), round(i,5));   
    });
    test(r"\int_0^1 \sqrt{1-x^2}) dx = \pi/4", () {
      num r = quad.integrate(100000, (x) => sqrt(1-x*x), 0.0, 1.0);
      num i = PI/4;
      expect(round(r, 6), round(i,6));   
    });
    test(r"\int_0^1 \frac{\sqrt{x}}{\sqrt{1-x^2}}) dx = 2\sqrt{\pi}\Gamma(3/4)/\Gamma(1/4)", () {
      //GaussLegendreIntegrator quad = new GaussLegendreIntegrator(1024, relativeAccuracy: 1.0e-6);
      num r = quad.integrate(1000000, (x) => sqrt(x)/sqrt(1-x*x), 0.0, 1.0);
      num i = 2*sqrt(PI)*1.225416702465178/3.625609908221908;
      expect(round(r, 6), round(i,6));    
    });
    test(r"\int_0^1 \log(x)^2 dx = 2", () {
      num r = quad.integrate(100000, (x) => log(x)*log(x), 0.0, 1.0);
      num i = 2.0;
      expect(round(r, 6), round(i,6));    
    });
    test(r"\int_0^{\pi/2} \log(\cos x) dx = -\pi\log(2)/3", () {
      num r = quad.integrate(100000, (x) => log(cos(x)), 0.0, PI/2);
      num i = -PI*log(2.0)/2.0;
      expect(round(r, 6), round(i,6));   
    });
    test(r"\int_0^{\pi/2} \sqrt(\tan x) dx = \pi\sqrt(2)/2", () {
      num r = quad.integrate(40000000, (x) => sqrt(tan(x)), 0.0, PI/2);
      num i = PI*sqrt(2)/2.0;
      expect(round(r, 6), round(i,6));    
    });
    test(r"\int_0^{\infty} \frac{1}{1+x^2} dx = \pi/2", () {
      num r = quad.integrate(1000000, (x) => 1.0/(1.0 - 2.0*x + 2*x*x), 0.0, 1.0);
      num i = PI/2.0;
      expect(round(r, 6), round(i,6));    
    });
    test(r"\int_0^{\infty} \frac{e^{-x}}{\sqrt{x}} dx = \sqrt{\pi}", () {
      num r = quad.integrate(100000, (x) => exp(1-1.0/x)/sqrt(pow(x,3)-pow(x,4)), 0.0, 1.0);
      num i = sqrt(PI);
      expect(round(r, 6), round(i,6));     
    });
    test(r"\int_0^{\infty} e^{-x^2/2} dx = \sqrt{\pi/2}", () {
      num r = quad.integrate(100000, (x) => exp(-0.5*pow(1.0/x-1, 2))/pow(x,2), 0.0, 1.0);
      num i = sqrt(PI/2.0);
      expect(round(r, 6), round(i,6));   
    });
    test(r"\int_0^{\infty} e^{-x}\cos x dx = 1/2", () {
      num r = quad.integrate(100000, (x) => exp(1-1/x)*cos(1/x-1)/pow(x,2), 0.0, 1.0);
      num i = 0.5;
      expect(round(r, 6), round(i,6));   
    });
    solo_test(r"\int_0^1 x^6 \sin(10\pi x) dx = 0.0059568281477...", () {
      num r = quad.integrate(100000, (x) => pow(x,6)*cos(10*PI*x), 0.0, 1.0);
      num i = 0.005956828147744827278016119076475372232470412836389028335703;
      //expect(round(r, 6), round(i,6));   
    });    
    
  });
  
  
  group("Filon integrator", () {
    FilonIntegrator quad = new FilonIntegrator(10*PI);
    
    test(r"\int_0^1 x^6 \cos(10\pi x) dx = 0.0059568281477...", () {
      num r = quad.integrate(100000, (x) => pow(x,6), 0.0, 1.0);
      num i = 0.005956828147744827278016119076475372232470412836389028335703;
      //expect(round(r, 6), round(i,6));   
    });    
    
  });
  
  
//  group("GaussLegendre integrator", () {
//    GaussLegendreIntegrator quad = new GaussLegendreIntegrator(1024);
//    test(r"\int_0^1 x \log(1+x) dx = 0.25", () {
//      num r = quad.integrate(100000, (x) => x*log(1+x), 0.0, 1.0);
//      expect(round(r, 2), 0.25);     
//    }); 
//    test(r"\int_0^1 x^2 \arctan(x) dx = (pi - 2 + 2log2)/12", () {
//      num r = quad.integrate(100000, (x) => pow(x,2)*atan(x), 0.0, 1.0);
//      num i = (PI - 2 + 2*log(2))/12;
//      expect(round(r, 6), round(i,6)); 
//    });
//    test(r"\int_0^{\pi/2} \exp(x)\cos(x) dx = (e^{\pi/2} - 1)/2", () {
//      num r = quad.integrate(100000, (x) => exp(x)*cos(x), 0.0, PI/2);
//      num i = 0.5*(exp(PI/2)-1);
//      expect(round(r, 5), round(i,5)); 
//    });
//    test(r"\int_0^1 \frac{\arctan(\sqrt{2+x^2})}{(1+x^2)\sqrt{2+x^2}} dx = 5\pi^2/96", () {
//      num r = quad.integrate(100000, (x) => atan(sqrt(2+x*x))/((1+x*x)*sqrt(2+x*x)), 0.0, 1.0);
//      num i = 5*PI*PI/96;
//      expect(round(r, 6), round(i,6)); 
//    });
//    test(r"\int_0^1 \sqrt{x}\log(x)) dx = -4/9", () {
//      num r = quad.integrate(100000, (x) => sqrt(x)*log(x), 0.0, 1.0);
//      num i = -4.0/9;
//      expect(round(r, 5), round(i,5));   
//    });
//    test(r"\int_0^1 \sqrt{1-x^2}) dx = \pi/4", () {
//      num r = quad.integrate(100000, (x) => sqrt(1-x*x), 0.0, 1.0);
//      num i = PI/4;
//      print(r);
//      expect(round(r, 6), round(i,6));   
//    });
//    test(r"\int_0^1 \frac{\sqrt{x}}{\sqrt{1-x^2}}) dx = 2\sqrt{\pi}\Gamma(3/4)/\Gamma(1/4)", () {
//      GaussLegendreIntegrator quad = new GaussLegendreIntegrator(1024, relativeAccuracy: 1.0e-6);
//      num r = quad.integrate(1000000, (x) => sqrt(x)/sqrt(1-x*x), 0.0, 1.0);
//      num i = 2*sqrt(PI)*1.225416702465178/3.625609908221908;
//      expect(round(r, 6), round(i,6));    // FAILS to converge, WolframAlpha calculates it 
//    });
//    test(r"\int_0^1 \log(x)^2 dx = 2", () {
//      num r = quad.integrate(100000, (x) => log(x)*log(x), 0.0, 1.0);
//      num i = 2.0;
//      expect(round(r, 6), round(i,6));    // FAILS
//    });
//    test(r"\int_0^{\pi/2} \log(\cos x) dx = -\pi\log(2)/3", () {
//      num r = quad.integrate(100000, (x) => log(cos(x)), 0.0, PI/2);
//      num i = -PI*log(2.0)/2.0;
//      expect(round(r, 6), round(i,6));   
//    });
//    test(r"\int_0^{\pi/2} \sqrt(\tan x) dx = \pi\sqrt(2)/2", () {
//      GaussLegendreIntegrator quad = new GaussLegendreIntegrator(1024, relativeAccuracy: 1.0e-6);
//      num r = quad.integrate(40000000, (x) => sqrt(tan(x)), 0.0, PI/2);
//      num i = PI*sqrt(2)/2.0;
//      expect(round(r, 6), round(i,6));    // FAILS to converge, WolframAlpha calculates it 
//    });
//    test(r"\int_0^{\infty} \frac{1}{1+x^2} dx = \pi/2", () {
//      num r = quad.integrate(1000000, (x) => 1.0/(1.0 - 2.0*x + 2*x*x), 0.0, 1.0);
//      num i = PI/2.0;
//      expect(round(r, 6), round(i,6));    
//    });
//    test(r"\int_0^{\infty} \frac{e^{-x}}{\sqrt{x}} dx = \sqrt{\pi}", () {
//      GaussLegendreIntegrator quad = new GaussLegendreIntegrator(1024, relativeAccuracy: 1.0e-6);
//      num r = quad.integrate(8000000, (x) => exp(1-1.0/x)/sqrt(pow(x,3)-pow(x,4)), 0.0, 1.0);
//      num i = sqrt(PI);
//      expect(round(r, 6), round(i,6));   // FAILS to converge, WolframAlpha calculates it  
//    });
//    test(r"\int_0^{\infty} e^{-t^2/2} dx = \sqrt{\pi/2}", () {
//      GaussLegendreIntegrator quad = new GaussLegendreIntegrator(1024, relativeAccuracy: 1.0e-6);
//      num r = quad.integrate(8000000, (x) => exp(-0.5*pow(1.0/x-1, 2))/pow(x,2), 0.0, 1.0);
//      num i = sqrt(PI/2.0);
//      expect(round(r, 6), round(i,6));   // FAILS to converge, WolframAlpha calculates it  
//    });
//  });  
//  
  
//  group("Trapezoid integrator", () {
//    TrapezoidIntegrator quad = new TrapezoidIntegrator();
//  group("Simpson integrator", () {
//    SimpsonIntegrator quad = new SimpsonIntegrator();
//    test(r"\int_0^1 x \log(1+x) dx = 0.25", () {
//      num r = quad.integrate(10000, (x) => x*log(1+x), 0.0, 1.0);
//      expect(round(r, 2), 0.25);      
//    }); 
//    test(r"\int_0^1 x^2 \arctan(x) dx = (pi - 2 + 2log2)/12", () {
//      num r = quad.integrate(10000, (x) => pow(x,2)*atan(x), 0.0, 1.0);
//      num i = (PI - 2 + 2*log(2))/12;
//      expect(round(r, 6), round(i,6)); 
//    });
//    test(r"\int_0^{\pi/2} \exp(x)\cos(x) dx = (e^{\pi/2} - 1)/2", () {
//      num r = quad.integrate(10000, (x) => exp(x)*cos(x), 0.0, PI/2);
//      num i = 0.5*(exp(PI/2)-1);
//      expect(round(r, 5), round(i,5)); 
//    });
//    test(r"\int_0^1 \frac{\arctan(\sqrt{2+x^2})}{(1+x^2)\sqrt{2+x^2}} dx = 5\pi^2/96", () {
//      num r = quad.integrate(10000, (x) => atan(sqrt(2+x*x))/((1+x*x)*sqrt(2+x*x)), 0.0, 1.0);
//      num i = 5*PI*PI/96;
//      expect(round(r, 6), round(i,6)); 
//    });
//    test(r"\int_0^1 \sqrt{x}\log(x)) dx = -4/9", () {
//      num r = quad.integrate(10000, (x) => sqrt(x)*log(x), 0.0, 1.0);
//      num i = -4.0/9;
//      expect(round(r, 6), round(i,6));   // FAILS
//    });
//    test(r"\int_0^1 \sqrt{1-x^2}) dx = \pi/4", () {
//      num r = quad.integrate(10000, (x) => sqrt(1-x*x), 0.0, 1.0);
//      num i = PI/4;
//      print(r);
//      expect(round(r, 6), round(i,6));   // FAILS
//    });
//    test(r"\int_0^1 \frac{\sqrt{t}}{\sqrt{1-x^2}}) dx = 2\sqrt{\pi}\Gamma(3/4)/\Gamma(1/4)", () {
//      num r = quad.integrate(10000, (x) => sqrt(x)/sqrt(1-x*x), 0.0, 1.0);
//      num i = 2*sqrt(PI)*1.225416702465178/3.625609908221908;
//      print(r);
//      expect(round(r, 6), round(i,6));    // FAILS
//    });
//    test(r"\int_0^1 \log(x)^2 dx = 2", () {
//      num r = quad.integrate(10000, (x) => log(x)*log(x), 0.0, 1.0);
//      num i = 2.0;
//      print(r);
//      expect(round(r, 6), round(i,6));    // FAILS
//    });
//  });
  

  
}