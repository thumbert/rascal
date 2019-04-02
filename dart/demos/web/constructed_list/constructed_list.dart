
import 'dart:html';
import 'package:elec_server/src/ui/autocomplete.dart';


class ConstructedList {

  Element wrapper;
  Autocomplete _autocomplete;
  List<String> _values;
  DivElement _wrapper;
  ButtonElement _addButton;
  DivElement _cl; // the constructed list

  ConstructedList(this.wrapper, List<String> values, {
    String placeholder}) {

    _wrapper = DivElement();

    var _wrapperAc = DivElement();
    _wrapperAc.setAttribute('style', 'float:left;');
    _autocomplete = Autocomplete(_wrapperAc, values, placeholder: placeholder);
    _wrapper.children.add(_wrapperAc);


    _cl = DivElement()..setAttribute('style', 'float:left;margin-top: 10px;');
    _autocomplete.onSelect((e) {
      var div = DivElement()..setAttribute('style', 'display:inline-block');
      div.children.add(ImageElement(src: 'deletion_icon.svg', width: 16, height: 16)
        ..setAttribute('style', 'float:left;margin-right: 5px;'));
      div.children.add(DivElement()..text = _autocomplete.value..setAttribute('style', 'float:left;'));
      _cl.children.add(div);
    });


    wrapper.children.add(_wrapper);
    wrapper.children.add(BRElement());
    wrapper.children.add(_cl);

  }

//  set values(List<String> xs) {
//    print('here');
//    _values = List.from(xs);
//
//    var _wId = wrapper.id;
//
//    // create the actual tabs
//    _buttonWrapper = DivElement()..className = _buttonWrapperClass;
//    for (var value in _values) {
//      var btn = ButtonElement()
//        ..id = 'btn-$value'
//        ..className = 'w3-bar-item w3-button'
//        ..text = value;
//      _buttonWrapper.children.add(btn);
//    }
//    _wrapper.children.add(_buttonWrapper);
//
//    // create the divs that keep the tab content
//    _tabContentDivs = <DivElement>[];
//    for (var value in _values) {
//      var tabContent = DivElement()
//        ..id = 'wrapper-$value-content';
//      var div = DivElement()
//          ..id = value
//          ..className = 'tab-content'
//          ..setAttribute('style', 'display:none');
//      div.children.add(tabContent);
//      _tabContentDivs.add(div);
//    }
//    _wrapper.children.addAll(_tabContentDivs);
//  }


}


List<String> getCountries() {
  return [
    "Afghanistan",
    "Albania",
    "Algeria",
    "Andorra",
    "Angola",
    "Anguilla",
    "Antigua & Barbuda",
    "Argentina",
    "Armenia",
    "Aruba",
    "Australia",
    "Austria",
    "Azerbaijan",
    "Bahamas",
    "Bahrain",
    "Bangladesh",
    "Barbados",
    "Belarus",
    "Belgium",
    "Belize",
    "Benin",
    "Bermuda",
    "Bhutan",
    "Bolivia",
    "Bosnia & Herzegovina",
    "Botswana",
    "Brazil",
    "British Virgin Islands",
    "Brunei",
    "Bulgaria",
    "Burkina Faso",
    "Burundi",
    "Cambodia",
    "Cameroon",
    "Canada",
    "Cape Verde",
    "Cayman Islands",
    "Central Arfrican Republic",
    "Chad",
    "Chile",
    "China",
    "Colombia",
    "Congo",
    "Cook Islands",
    "Costa Rica",
    "Cote D Ivoire",
    "Croatia",
    "Cuba",
    "Curacao",
    "Cyprus",
    "Czech Republic",
    "Denmark",
    "Djibouti",
    "Dominica",
    "Dominican Republic",
    "Ecuador",
    "Egypt",
    "El Salvador",
    "Equatorial Guinea",
    "Eritrea",
    "Estonia",
    "Ethiopia",
    "Falkland Islands",
    "Faroe Islands",
    "Fiji",
    "Finland",
    "France",
    "French Polynesia",
    "French West Indies",
    "Gabon",
    "Gambia",
    "Georgia",
    "Germany",
    "Ghana",
    "Gibraltar",
    "Greece",
    "Greenland",
    "Grenada",
    "Guam",
    "Guatemala",
    "Guernsey",
    "Guinea",
    "Guinea Bissau",
    "Guyana",
    "Haiti",
    "Honduras",
    "Hong Kong",
    "Hungary",
    "Iceland",
    "India",
    "Indonesia",
    "Iran",
    "Iraq",
    "Ireland",
    "Isle of Man",
    "Israel",
    "Italy",
    "Jamaica",
    "Japan",
    "Jersey",
    "Jordan",
    "Kazakhstan",
    "Kenya",
    "Kiribati",
    "Kosovo",
    "Kuwait",
    "Kyrgyzstan",
    "Laos",
    "Latvia",
    "Lebanon",
    "Lesotho",
    "Liberia",
    "Libya",
    "Liechtenstein",
    "Lithuania",
    "Luxembourg",
    "Macau",
    "Macedonia",
    "Madagascar",
    "Malawi",
    "Malaysia",
    "Maldives",
    "Mali",
    "Malta",
    "Marshall Islands",
    "Mauritania",
    "Mauritius",
    "Mexico",
    "Micronesia",
    "Moldova",
    "Monaco",
    "Mongolia",
    "Montenegro",
    "Montserrat",
    "Morocco",
    "Mozambique",
    "Myanmar",
    "Namibia",
    "Nauro",
    "Nepal",
    "Netherlands",
    "Netherlands Antilles",
    "New Caledonia",
    "New Zealand",
    "Nicaragua",
    "Niger",
    "Nigeria",
    "North Korea",
    "Norway",
    "Oman",
    "Pakistan",
    "Palau",
    "Palestine",
    "Panama",
    "Papua New Guinea",
    "Paraguay",
    "Peru",
    "Philippines",
    "Poland",
    "Portugal",
    "Puerto Rico",
    "Qatar",
    "Reunion",
    "Romania",
    "Russia",
    "Rwanda",
    "Saint Pierre & Miquelon",
    "Samoa",
    "San Marino",
    "Sao Tome and Principe",
    "Saudi Arabia",
    "Senegal",
    "Serbia",
    "Seychelles",
    "Sierra Leone",
    "Singapore",
    "Slovakia",
    "Slovenia",
    "Solomon Islands",
    "Somalia",
    "South Africa",
    "South Korea",
    "South Sudan",
    "Spain",
    "Sri Lanka",
    "St Kitts & Nevis",
    "St Lucia",
    "St Vincent",
    "Sudan",
    "Suriname",
    "Swaziland",
    "Sweden",
    "Switzerland",
    "Syria",
    "Taiwan",
    "Tajikistan",
    "Tanzania",
    "Thailand",
    "Timor L'Este",
    "Togo",
    "Tonga",
    "Trinidad & Tobago",
    "Tunisia",
    "Turkey",
    "Turkmenistan",
    "Turks & Caicos",
    "Tuvalu",
    "Uganda",
    "Ukraine",
    "United Arab Emirates",
    "United Kingdom",
    "United States of America",
    "Uruguay",
    "Uzbekistan",
    "Vanuatu",
    "Vatican City",
    "Venezuela",
    "Vietnam",
    "Virgin Islands (US)",
    "Yemen",
    "Zambia",
    "Zimbabwe"
  ];
}

main() {
  var countries = getCountries();

  var wrapper = querySelector('#wrapper-constructed-list')
    ..setAttribute('style', 'margin-left: 15px');
  var message = querySelector('#message');

  var cl = ConstructedList(wrapper, countries, placeholder: 'Country name');

  //cl.onSelect((e) => message.text = 'You selected ${ac.value}');

}



