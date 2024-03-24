import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:layout_editor/component_widget.dart';
import 'package:layout_editor/style_element.dart';
import 'package:provider/provider.dart';

import 'layout_model.dart';

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

    LayoutModel layoutModel = context.read<LayoutModel>();
    var style = layoutModel.getStyleElementById(component['style'].id) ??
        StyleElement("стиль");

    return Container(
      alignment: component['alignment'],
      child: Text(
        text,
        style: TextStyle(
            color: style['color'],
            fontWeight: style['fontWeight'],
            fontSize: style['fontSize']),
      ),
    );
  }
}
