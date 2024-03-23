import 'package:flutter/material.dart';
import 'package:layout_editor/property.dart';
import 'package:layout_editor/style.dart';

class StyleElement extends LayoutStyle {
  StyleElement(name) : super("styleElement", name) {
    properties["color"] = Property("цвет", Colors.black, type: Color);
    properties["backgroundColor"] = Property("цвет фона", Colors.blue, type: Color);
    properties["alignment"] =
        Property("выравнивание", Alignment.centerLeft, type: Alignment);
    properties["fontSize"] = Property("размер шрифта", 11, type: int);
    properties["fontWeight"] = Property("насыщенность шрифта", FontWeight.normal, type: FontWeight);
  }

}

