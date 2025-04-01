import 'package:flutter/material.dart';
import 'canvas/layout_model_inherit.dart';
import 'component_widget.dart';
import 'hidden_field_file.dart';
import 'style_element.dart';

class FormHiddenFieldWidget extends ComponentWidget {
  const FormHiddenFieldWidget({required super.component,required super.controller,super.key, super.screenSize});

  @override
  Widget buildWidget(BuildContext context) {
    String text = component['source']?.isNotEmpty ?? false
        ? '\$${component["source"]}'
        : '';
    if (text.isEmpty) {
      text = component['text'] ?? '';
    }
    final layoutModel = LayoutModelInheritedWidget.of(context).layoutModel;
    var style = layoutModel.getStyleElementById(component['style'].id) ??
        StyleElement("стиль");
    if (component['style']?.name == 'вложение') {
      return HiddenFieldFile(component: component);
    } else if (component['name'] == 'фото') {
     // return PhotoSignHiddenField(component: component);
    }
    return Text(component['id'].toString());

  }
}
