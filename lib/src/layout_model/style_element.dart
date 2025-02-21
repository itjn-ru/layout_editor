import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import 'constants.dart';
import 'package:flutter/material.dart';
import 'property.dart';
import 'style.dart';

class StyleElement extends LayoutStyle {
  StyleElement(name) : super("styleElement", name) {
   if(kDebugMode) properties['id'] = Property("идентификатор", const Uuid().v4(), type: String);
    properties['color'] = Property("цвет", Colors.black, type: Color);
    properties['backgroundColor'] = Property("цвет фона", Colors.transparent, type: Color);
    properties['alignment'] =
        Property("выравнивание", Alignment.centerLeft, type: Alignment);
    properties['fontSize'] = Property("размер шрифта", 11, type: double);
    properties['fontWeight'] = Property("насыщенность шрифта", FontWeight.normal, type: FontWeight);
  }

}

