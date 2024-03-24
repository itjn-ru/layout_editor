import 'package:flutter/material.dart';
import 'package:layout_editor/property.dart';
import 'package:layout_editor/style.dart';
import 'package:uuid_type/uuid_type.dart';

class StyleElement extends LayoutStyle {
  StyleElement(name) : super("styleElement", name) {
    properties['id'] =
        Property("идентификатор", Uuid.parse(uuid.v4()), type: Uuid);
    properties['color'] = Property("цвет", Colors.black, type: Color);
    properties['backgroundColor'] = Property("цвет фона", Colors.transparent, type: Color);
    properties['alignment'] =
        Property("выравнивание", Alignment.centerLeft, type: Alignment);
    properties['fontSize'] = Property("размер шрифта", 11, type: double);
    properties['fontWeight'] = Property("насыщенность шрифта", FontWeight.normal, type: FontWeight);
  }

}

