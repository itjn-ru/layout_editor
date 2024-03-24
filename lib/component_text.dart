import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:layout_editor/component.dart';
import 'package:layout_editor/property.dart';
import 'package:layout_editor/style.dart';

import 'item.dart';

class ComponentText extends LayoutComponent {
  ComponentText(name) : super("text", name) {
    properties["text"] = Property("текст", "");
    properties["source"] = Property("источник", "");
    properties["alignment"] =
        Property("выравнивание", Alignment.centerLeft, type: Alignment);
    properties["style"] = Property("стиль", Style.basic, type: Style);
  }
}
