import 'package:flutter/material.dart';
import 'package:layout_editor/component_widget.dart';

class FormHiddenFieldWidget extends ComponentWidget {
  FormHiddenFieldWidget(component) : super(component);

  @override
  Widget buildWidget(BuildContext context) {
    String text = component["source"]?.isNotEmpty ?? false
        ? "\$" + component["source"] ?? ""
        : "";
    if (text.isEmpty) {
      text = component["text"] ?? "";
    }

    return Text("");

  }
}
