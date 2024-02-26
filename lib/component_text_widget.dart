import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:layout_editor/component_table.dart';
import 'package:layout_editor/component_widget.dart';
import 'package:layout_editor/item.dart';

class ComponentTextWidget extends ComponentWidget {
  ComponentTextWidget(component) : super(component);

  @override
  Widget buildWidget(BuildContext context) {
    String text = component["source"]?.isNotEmpty ?? false
        ? "\$" + component["source"] ?? ""
        : "";
    if (text.isEmpty) {
      text = component["text"] ?? "";
    }

    return Container(
      alignment: component['alignment'],
      child: Text(
        text,
        style: component['textStyle'],
      ),
    );
  }
}
