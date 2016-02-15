library graphics.key;

import 'package:stagexl/stagexl.dart';
import 'package:demos/graphics/drawable.dart';


class Key extends Sprite {

  List<String> labels;
  List<int> colors;
  List<TextField> _textFields;

  /// A key providing an explanation of the symbols in the figure.
  /// Can be placed in various positions (outside or inside the plotting area).
  ///
  Key(this.labels, {this.colors}) {

    _textFields = labels.map((e) {
      var tx = new TextField(e)
        ..autoSize = TextFieldAutoSize.CENTER;

    }).toList();


  }

}

/// A figure key is composed of several key entries
/// Each key entry is a pair of <symbol, text>
/// The key entries are arranged vertically or horizontally on different
/// parts of the figure.
class _KeyEntry extends Sprite {

  _KeyEntry(TextField text, int color, {int lineLength: 30}){

  }

}