
import 'package:flutter/material.dart';
import 'component_widget.dart';
import 'style_element.dart';

class ComponentTextWidget extends ComponentWidget {
  const ComponentTextWidget({required super.component,required super.controller,super.key, super.screenSize});

  @override
  Widget buildWidget(BuildContext context) {
    String text = component["text"] ?? "";
    text += component["source"]?? "";
    final layoutModel = controller.layoutModel;
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
