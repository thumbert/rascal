// library test.string.regexp;


// /// extract all href from a page
// extractHref(){
//   var str = """
//         <li><a href="/content/docs/default-source/default-document-library/customer-count-report---february-20189d8aa40f1b5267e39dbdff3500e2e88e.xlsx?sfvrsn=71d8c362_0" title="Customer Count Report - February 2018" target="_blank">Customer Count Report - February 2018</a></li>
//         <li><a href="/content/docs/default-source/default-document-library/customer-count-report---january-20187c8aa40f1b5267e39dbdff3500e2e88e.xlsx?sfvrsn=92d8c362_0" title="Customer Count Report - January 2018" target="_blank">Customer Count Report - January 2018</a></li>
//         <li><a href="/content/docs/default-source/default-document-library/customer-count-report---december-2017428aa40f1b5267e39dbdff3500e2e88e.xlsx?sfvrsn=d8d8c362_0" title="Customer Count Report - December 2017" target="_blank">Customer Count Report - December 2017</a></li>
//         <li><a href="/content/docs/default-source/ct---pdfs/customer-count-report---november-2017.xlsx?sfvrsn=6506c462_0" title="Customer Count Report - November 2017">Customer Count Report - November 2017</a></li>
//         <li><a href="/content/docs/default-source/ct---pdfs/customer-count-report---october-2017.xlsx?sfvrsn=9406c462_0" title="Customer Count Report - October 2017">Customer Count Report - October 2017</a></li>
//         <li><a href="/content/docs/default-source/ct---pdfs/customer-count-report----september-2017.xlsx?sfvrsn=bb06c462_0" title="Customer Count Report -- September 2017">Customer Count Report -- September 2017</a></li>
//         <li><a href="/content/docs/default-source/ct---pdfs/2017-08.xlsx?sfvrsn=7f59c762_2" title="Customer Count Report - August 2017">Customer Count Report - August 2017</a></li>
//         <li><a href="/content/docs/default-source/ct---pdfs/2017-07.xlsx?sfvrsn=7859c762_2" title="Customer Count Report - July 2017">Customer Count Report - July 2017</a></li>
//         <li><a href="/content/docs/default-source/ct---pdfs/2017-06.xlsx?sfvrsn=7959c762_2" title="Customer Count Report - June 2017">Customer Count Report - June 2017</a></li>
//         <li><a href="/content/docs/default-source/ct---pdfs/2017-05.xlsx?sfvrsn=d6a6fb62_2" title="Customer Count Report - May 2017" target="_blank">Customer Count Report - May 2017</a></li>
//         <li><a href="/content/docs/default-source/ct---pdfs/2017-04.xlsx?sfvrsn=77a6fb62_2" title="Customer Count Report - April 2017" target="_blank">Customer Count Report - April 2017</a></li>
//         <li><a href="/content/docs/default-source/ct---pdfs/2017-03.xlsx?sfvrsn=70a6fb62_2" title="Customer Count Report - March 2017" target="_blank">Customer Count Report - March 2017</a></li>
//         <li><a href="/content/docs/default-source/ct---pdfs/2017-02.xlsx?sfvrsn=fa35fc62_2" title="Customer Count Report - February 2017" target="_blank">Customer Count Report - February 2017</a></li>
//         <li><a href="/content/docs/default-source/ct---pdfs/2017-01.xlsx?sfvrsn=fb35fc62_2" title="Customer Count Report - January 2017" target="_blank">Customer Count Report - January 2017</a></li>
//         <li><a href="/content/docs/default-source/ct---pdfs/2016-12-(2).xlsx?sfvrsn=9d35fc62_2" title="Customer Count Report - December 2016" target="_blank">Customer Count Report - December 2016</a></li>
//         <li><a href="/content/docs/default-source/ct---pdfs/2016-11.xlsx?sfvrsn=3f88fe62_2" title="Customer Count Report - November 2016" target="_blank">Customer Count Report - November 2016</a><a href="/content/docs/default-source/ct---pdfs/2016-10.xlsx?sfvrsn=f88fe62_2"></a>
//         </li>
//         <li><a href="/content/docs/default-source/ct---pdfs/2016-10.xlsx?sfvrsn=f88fe62_2"></a><a href="/content/docs/default-source/ct---pdfs/2016-10.xlsx?sfvrsn=f88fe62_2" title="Customer Count Report - October 2016" target="_blank">Customer Count Report - October 2016</a></li>
//         <li><a href="/content/docs/default-source/ct---pdfs/2016-09.xlsx?sfvrsn=1f88fe62_2" title="Customer Count Report - September 2016" target="_blank">Customer Count Report - September 2016</a></li>
//         <li><a href="/content/docs/default-source/ct---pdfs/2016-08.xlsx?sfvrsn=78fcff62_2" title="Customer Count Report - August 2016">Customer Count Report - August 2016</a></li>
//         <li><a href="/content/docs/default-source/ct---pdfs/2016-07.xlsx?sfvrsn=76fcff62_2" title="Customer Count Report - July 2016">Customer Count Report - July 2016</a></li>
//         <li style="text-align: left;"><a href="/content/docs/default-source/ct---pdfs/2016-06.xlsx?sfvrsn=6cfcff62_2" title="Customer Count Report - June 2016">Customer Count Report - June 2016</a></li>
//         <li><a href="/content/docs/default-source/ct---pdfs/2016-05.xlsx?sfvrsn=c7ebf062_0" title="Customer Count Report - May 2016">Customer Count Report - May 2016</a></li>
//         <li><a href="/content/docs/default-source/ct---pdfs/2016-04.xlsx?sfvrsn=f3ebf062_0" title="Customer Count Report - April 2016">Customer Count Report - April 2016</a></li>
//         <li><a href="/content/docs/default-source/ct---pdfs/2016-03.xlsx?sfvrsn=efebf062_0" title="Customer Count Report - March 2016">Customer Count Report - March 2016</a></li>
//         <li><a href="/content/docs/default-source/ct---pdfs/2016-02.xlsx?sfvrsn=c61af362_0" title="Customer Count Report - February 2016">Customer Count Report - February 2016</a></li>
//         <li><a href="/content/docs/default-source/ct---pdfs/2016-01.xlsx?sfvrsn=f21af362_0" title="Customer Count Report - January 2016">Customer Count Report - January 2016</a></li>
//         <li><a href="/content/docs/default-source/ct---pdfs/2015-12.xlsx?sfvrsn=ee1af362_0" title="Customer Count Report - December 2015">Customer Count Report - December 2015</a></li>
//         <li><a href="/content/docs/default-source/ct---pdfs/2015-11.xlsx?sfvrsn=bfccf562_0" title="Customer Count Report - November 2015">Customer Count Report - November 2015</a></li>
//         <li><a href="/content/docs/default-source/ct---pdfs/2015-10.xlsx?sfvrsn=83ccf562_0" title="Customer Count Report - October 2015">Customer Count Report - October 2015</a></li>
//         <li><a href="/content/docs/default-source/ct---pdfs/2015-09.xlsx?sfvrsn=97ccf562_0" title="Customer Count Report - September 2015">Customer Count Report - September 2015</a></li>
//         <li><a href="/content/docs/default-source/ct---pdfs/2015-08.xlsx?sfvrsn=3bc0f662_0" title="Customer Count Report - August 2015">Customer Count Report - August 2015</a></li>
//         <li><a href="/content/docs/default-source/ct---pdfs/2015-07.xlsx?sfvrsn=37c0f662_0" title="Customer Count Report - July 2015">Customer Count Report - July 2015</a></li>
//         <li><a href="/content/docs/default-source/ct---pdfs/2015-06.xlsx?sfvrsn=23c0f662_0" title="Customer Count Report - June 2015">Customer Count Report - June 2015</a></li>
//         <li><a href="/content/docs/default-source/ct---pdfs/2015-05.xlsx?sfvrsn=f994e862_0" title="Customer Count Report - May 2015">Customer Count Report - May 2015</a></li>
//         <li><a href="/content/docs/default-source/ct---pdfs/2015-04.xlsx?sfvrsn=f594e862_0" title="Customer Count Report - April 2015">Customer Count Report - April 2015</a></li>
//         <li><a href="/content/docs/default-source/ct---pdfs/2015-03.xlsx?sfvrsn=e194e862_0" title="Customer Count Report - March 2015">Customer Count Report - March 2015</a></li>
//         <li><a href="/content/docs/default-source/ct---pdfs/2015-02.xlsx?sfvrsn=1d97e862_0" title="Customer Count Report - February 2015">Customer Count Report - February 2015</a></li>
//         <li><a href="/content/docs/default-source/ct---pdfs/2015-01.xlsx?sfvrsn=4f0aeb62_0" title="Customer Count Report - January 2015">Customer Count Report - January 2015</a></li>
//         <li><a href="/content/docs/default-source/ct---pdfs/2014-12.xlsx?sfvrsn=aecbec62_0" title="Customer Count Report - December 2014">Customer Count Report - December 2014</a></li>
//         <li><a href="/content/docs/default-source/ct---pdfs/2014-11.xlsx?sfvrsn=6168ec62_2" title="Customer Count Reports - November 2014">Customer Count Report - November 2014</a></li>
//         <li><a href="/content/docs/default-source/wma---pdfs/2014-10.xlsx?sfvrsn=7568ec62_0" title="Customer Count Reports - October 2014">Customer Count Report - October 2014</a></li>
//         <li><a href="/content/docs/default-source/ct---pdfs/2014-09.xlsx?sfvrsn=7968ec62_0" title="Customer Count Reports - September 2014">Customer Count Report - September 2014</a></li>
//         <li><a href="/content/docs/default-source/ct---pdfs/2014-08.xlsx?sfvrsn=4d68ec62_0" title="Customer Count Reports - August 2014">Customer Count Report - August 2014</a></li>
//         <li><a href="/content/docs/default-source/ct---pdfs/2014-07.xlsx?sfvrsn=5168ec62_0" title="Customer Count Reports - July 2014">Customer Count Report - July 2014</a></li>
//         <li><a href="/content/docs/default-source/ct---pdfs/2014-06.xlsx?sfvrsn=2568ec62_0" title="Customer Count Reports - June 2014">Customer Count Report - June 2014</a></li>
//         <li><a href="/content/docs/default-source/ct---pdfs/2014-05.xlsx?sfvrsn=2968ec62_0" title="Customer Count Reports - May 2014">Customer Count Report - May 2014</a></li>
//         <li><a href="/content/docs/default-source/ct---pdfs/2014-04.xlsx?sfvrsn=3d68ec62_0" title="Customer Count Reports - April 2014">Customer Count Report - April 2014</a></li>
//         <li><a href="/content/docs/default-source/ct---pdfs/2014-03.xlsx?sfvrsn=168ec62_0" title="Customer Count Reports - March 2014">Customer Count Report - March 2014</a></li>
//         <li><a href="/content/docs/default-source/ct---pdfs/2014-02.xlsx?sfvrsn=1568ec62_0" title="Customer Count Reports - February 2014">Customer Count Report - February 2014</a></li>
//         <li><a href="/content/docs/default-source/ct---pdfs/2014-01.xlsx?sfvrsn=1968ec62_0" title="Customer Count Reports - January 2014">Customer Count Report - January 2014</a></li>  
//   """;
//   var lines = str.split('\n');

//   RegExp reg = new RegExp(r'(.*)href="(.*)" title(.*)');

// //  var months = new TimeIterable(new Month(2018, 2), new Month(2014, 1), step: -1).toList();
// //  var i = 0;
// //
// //  lines.forEach((line) {
// //    var matches = reg.allMatches(line);
// //    if (matches.length > 0) {
// //      var match = matches.elementAt(0);
// ////  print(match.groupCount);
// ////  print(match.group(0));
// ////  print(match.group(1));
// //      int year = months[i].year;
// //      int month = months[i].month;
// //      print("new Month($year,$month): '${match.group(2)}',");
// //      i++;
// //    }
// //  });
// }

// /// Replace digits in string
// replaceDigits() {
//   var str = 'left:19.3%;right:40%;';
//   /// replace the 19.3 with 31
//   var reg = RegExp(r'left:(\d+(.\d+)?)%;');
//   print(reg.hasMatch(str));
//   var matches = reg.allMatches(str);
//   var match = matches.elementAt(0);
// //  print(match.groupCount);
// //  print(match.group(0));
// //  print(match.group(1));
//   var str3 = str.replaceFirst(match.group(1), '31');
//   print(str3);  // left:31%;right:40%;
// }



// main() {
//   replaceDigits();

//   //extractHref();

// }