import 'package:flutter/material.dart';
import 'package:layout_editor/component_widget.dart';

class FormTextFieldWidget extends ComponentWidget {
  FormTextFieldWidget(component) : super(component);

  @override
  Widget buildWidget(BuildContext context) {
    String text = component["source"]?.isNotEmpty ?? false
        ? "\$" + component["source"] ?? ""
        : "";
    if (text.isEmpty) {
      text = component["text"] ?? "";
    }

    return TextField(
      readOnly: true,
      decoration: InputDecoration(hintText: component['caption']),
    );
  }
}
