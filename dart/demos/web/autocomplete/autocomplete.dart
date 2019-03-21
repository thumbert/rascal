import 'dart:html';

/// Port of https://www.w3schools.com/howto/howto_js_autocomplete.asp

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

class Autocomplete {

  DivElement wrapper;
  InputElement _input;
  List<String> values;

  String _value;

  DivElement _al;  // autocomplete-list
  int _currentFocus;

  Autocomplete(this.wrapper, this.values) {
    _input = InputElement(type: 'text')
      ..name = 'myCountry'
      ..id = '${wrapper.id}-input'
      ..placeholder = 'Country';

    // a div element that will hold all the items
    _al = DivElement()
      ..setAttribute('id', '${_input.id}autocomplete-list')
      ..setAttribute('class', 'autocomplete-items');


    _input.onInput.listen((e) {
      _value = _input.value;
      _closeAllLists();
      _currentFocus = -1;

      print('in the onInput event');

      for (var value in values
          .where((e) => e.toUpperCase().startsWith(_value.toUpperCase()))) {
        var _b = DivElement();
        _b.innerHtml = '<strong>${value.substring(0, _value.length)}</strong>';
        _b.innerHtml += value.substring(_value.length);
        _b.innerHtml += '<input type="hidden" value="${value}">';
        _b.addEventListener('click', (e) {
          _input.value = _input.children.first.nodeValue;
          _closeAllLists();
        });
        _al.children.add(_b);
      }
    });


    _input.onKeyDown.listen((e) {
      print('here');
      if (_al == null) return;
      var _xs = _al.children.cast<DivElement>();
      if (e.keyCode == 40) {
        // if arrow DOWN is pressed
        _currentFocus++;
        _addActive(_xs);
      } else if (e.keyCode == 38) {
        // if arrow UP is pressed
        _currentFocus--;
        _addActive(_xs);
      } else if (e.keyCode == 13) {
        // if ENTER is pressed
        e.preventDefault();
        if (_currentFocus > -1 && _xs.isNotEmpty)
          _xs[_currentFocus].click();
      }
    });

    _input.onClick.listen((e) {
      _closeAllLists();
    });

    wrapper.children.add(_input);
    wrapper.children.add(_al);
  }

  void _addActive(List<DivElement> xs) {
    _removeActive(xs);
    if (_currentFocus >= xs.length) _currentFocus = 0;
    if (_currentFocus < 0) _currentFocus = xs.length - 1;
    xs[_currentFocus].classes.add('autocomplete-active');
  }

  void _removeActive(List<DivElement> xs) {
    for (var i=0; i<xs.length; i++) {
      xs[i].classes.remove('autocomplete-active');
    }
  }

  void _closeAllLists() {
    _al.children.clear();
  }

}

main() {
  var countries = getCountries();

  var wrapper = querySelector('#wrapper-ac');

  Autocomplete(wrapper, countries);

}








