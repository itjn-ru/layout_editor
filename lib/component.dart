import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:layout_editor/component_widget.dart';
import 'package:layout_editor/item.dart';
import 'package:layout_editor/property.dart';

import 'component_and_source.dart';

class LayoutComponent extends LayoutComponentAndSource {
  LayoutComponent(super.type, super.name) {
    properties["position"] = Property("положение", Offset(0, 0), type: Offset);
    properties["size"] = Property("размер", Size(360, 30), type: Size);
  }
}