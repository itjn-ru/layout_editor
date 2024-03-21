import 'package:flutter/material.dart';
import 'package:layout_editor/item.dart';
import 'package:layout_editor/property.dart';
import 'package:layout_editor/source.dart';

class StyleElement extends LayoutSource {
  StyleElement(name) : super("paletteColor", name) {
    properties["color"] = Property("цвет", Colors.blue, type: Color);
  }

}

