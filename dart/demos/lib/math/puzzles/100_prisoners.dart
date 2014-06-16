library prisoners;
import 'dart:math';

/*
 * http://tierneylab.blogs.nytimes.com/2009/03/23/the-puzzle-of-100-hats/?_php=true&_type=blogs&_php=true&_type=blogs&_r=1
 * One hundred persons will be lined up single file, facing north. Each person will be assigned 
 * either a red hat or a blue hat. No one can see the color of his or her own hat. However, 
 * each person is able to see the color of the hat worn by every person in front of him or her. 
 * That is, for example, the last person in line can see the color of the hat on 99 persons in 
 * front of him or her; and the first person, who is at the front of the line, cannot see 
 * the color of any hat.
 * 
 * Beginning with the last person in line, and then moving to the 99th person, the 98th, etc., 
 * each will be asked to name the color of his or her own hat. If the color is correctly named, 
 * the person lives; if incorrectly named, the person is shot dead on the spot. Everyone in line 
 * is able to hear every response as well as hear the gunshot; also, everyone in line is able to 
 * remember all that needs to be remembered and is able to compute all that needs to be computed.
 * 
 * Before being lined up, the 100 persons are allowed to discuss strategy, with an eye toward 
 * developing a plan that will allow as many of them as possible to name the correct color of his 
 * or her own hat (and thus survive). They know all of the preceding information in this problem. 
 * Once lined up, each person is allowed only to say “Red” or “Blue” when his or her turn arrives, 
 * beginning with the last person in line.
 * 
 * Your assignment: Develop a plan that allows as many people as possible to live. (Do not waste 
 * time attempting to evade the stated bounds of the problem — there’s no trick to the answer.)
 */

class Scenario {
  List<bool> value;
  
  Scenario(int N){
    var gen = new Random();
    value = new List.generate(N, (int i) => gen.nextBool(), growable: false);  
  }
  
  Map count({int from: 0}) {
    int nTrue  = 0;
    int nFalse = 0;
    for (int i=from; i<value.length; i++) {
      if (value[i]) nTrue += 1; 
      else nFalse += 1;
    }
    return {'nTrue': nTrue, 'nFalse': nFalse};
  }
  
  void run(Strategy strategy) {}
}

abstract class Strategy {
  List<bool> state;           // the truth
  List<bool> guess;           // the guess
  
  // return the guess
  List<bool> decision();
  
  Map stats() {
    int saved = getSaved();
    return {'saved' : saved};
  }
  
  // calculate how many people are saved
  int getSaved() {
    int saved = 0;
    for (int i=0; i<state.length; i++) {
      if (guess[i] == state[i])
        saved += 1;
    }
    
    return saved;
  }
}

/*
 * Simple strategy -- sacrifice.  Odd guys say the color of the guys just ahead of them.
 * So all the even persons are safe.  The odd guys occasionally get lucky. 
 * 
 */
class Strategy1 extends Strategy {
  
  Strategy1(List<bool> state) {
    this.state = state; 
    this.guess = decision();
  }
  
  List<bool> decision() {
    var N = state.length;
    List<bool> guess = new List<bool>(N);
    
    for (int i=0; i<N; i++) {
      if (i % 2 == 1) {               // odd guy in line
        guess[i] = state[i+1];        // sacrifices
      } else {
        guess[i] = guess[i-1];        // trust the guy behind
      }
    } 
    
    return guess;
  }

}



class Problem {
  int N;                   // number of persons
  int S;                   // number of simulations
  List<Scenario> scenarios;  
  
  Problem({int N: 100, int S: 10}) {
    assert(N % 2 == 0);    // make it work for even number of prisoners only ... 
    this.N = N;
    this.S = S;
    scenarios = new List.generate(S, (i) => new Scenario(N), growable: false);  
  }
  
  void run(Strategy strategy) {
    var res = scenarios.map((scenario) {
      var guess = strategy.decision();
    });
  }
  
  void report() {
    
  }
  
  
}




