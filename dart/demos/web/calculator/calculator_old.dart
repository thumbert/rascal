library ui.calculator;

import 'dart:html' as html;


class Calculator {

  html.Element wrapper;

  Calculator(this.wrapper, {Map<String,dynamic> defaults}) {

  }

  Calculator.fromMap(this.wrapper, Map<String,dynamic> details) {

  }

}


main() async {

}


//grid-template-areas:
//'header header header header header header header'
//'column column column column column column column'
//'cell1  cell1  cell1  cell1  cell1  cell1  cell1'


//<div class="grid-item">MW</div>
//<div class="grid-item">ISO</div>


//<div class="item2">100</div>
//<div class="item2">ISONE</div>
//<div class="item2">Mass Hub</div>
//<div class="item2">DA</div>
//<div class="item2">LMP</div>
//<div class="item2">5x16</div>
//<div class="item2">81.50</div>
//
//<div class="item2">-100</div>
//<div class="item2">ISONE</div>
//<div class="item2">Mass Hub</div>
//<div class="item2">RT</div>
//<div class="item2">LMP</div>
//<div class="item2">5x16</div>
//<div class="item2">83.24</div>
