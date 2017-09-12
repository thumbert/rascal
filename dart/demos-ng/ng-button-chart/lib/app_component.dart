// Copyright (c) 2017, adrian. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import 'src/button_with_chart/button_with_chart.dart';


@Component(
  selector: 'my-app',
  styleUrls: const ['app_component.css'],
  templateUrl: 'app_component.html',
  directives: const [materialDirectives,
    ButtonWithChart,
  ],
  providers: const [materialProviders],
)
class AppComponent {}
