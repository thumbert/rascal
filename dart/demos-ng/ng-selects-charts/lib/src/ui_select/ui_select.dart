// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

@Component(
    selector: 'ui-select',
    templateUrl: 'ui_select.html',
    directives: const [
      MaterialExpansionPanel,
      MaterialExpansionPanelSet,
      MaterialTabComponent,
      MaterialTabPanelComponent,
    ])
class UiSelectComponent {
  // Nothing here.
}
