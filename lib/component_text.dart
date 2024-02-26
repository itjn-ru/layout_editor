import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:layout_editor/component.dart';
import 'package:layout_editor/property.dart';

import 'item.dart';

class ComponentText extends LayoutComponent {
  ComponentText(name) : super("text", name) {
    properties["text"] = Property("текст", "");
    properties["source"] = Property("источник", "");
    properties["alignment"] =
        Property("выравнивание", Alignment.centerLeft, type: Alignment);
    properties["textStyle"] = Property(
        "стиль текста",
        const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 11.0,
        ),
        type: TextStyle);
  }
}
