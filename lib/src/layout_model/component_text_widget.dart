
import 'package:flutter/material.dart';
import 'canvas/layout_model_inherit.dart';
import 'component_widget.dart';
import 'style_element.dart';

class ComponentTextWidget extends ComponentWidget {
  const ComponentTextWidget(super.component, super.controller, {super.key});

  @override
  Widget buildWidget(BuildContext context) {
    String text = component["text"] ?? "";
    text += component["source"]?? "";
    final layoutModel = LayoutModelInheritedWidget.of(context).layoutModel;
    var style = layoutModel.getStyleElementById(component['style'].id) ??
        StyleElement("стиль");
    final double fontSize= style['fontSize'];
    return Container(

      alignment: component['alignment'],
      child: Text(
        text,
        style: TextStyle(
          ///TODO не работает color при сохранении
            color: Colors.black,//style['color'],
            fontWeight: style['fontWeight'],
            fontSize: fontSize),
      ),
    );
  }
}
