import 'package:flutter/material.dart';
import 'property.dart';
import 'style.dart';
import 'package:uuid/uuid.dart';

class StyleElement extends LayoutStyle {
  StyleElement(name) : super("styleElement", name) {
    properties['id'] =
//        Property("идентификатор", Uuid.parse(uuid.v4()), type: Uuid);
    Property("идентификатор", const Uuid().v1obj(), type: UuidValue);
    properties['color'] = Property("цвет", Colors.black, type: Color);
    properties['backgroundColor'] = Property("цвет фона", Colors.transparent, type: Color);
    properties['alignment'] =
        Property("выравнивание", Alignment.centerLeft, type: Alignment);
    properties['fontSize'] = Property("размер шрифта", 11, type: double);
    properties['fontWeight'] = Property("насыщенность шрифта", FontWeight.normal, type: FontWeight);
  }

}

