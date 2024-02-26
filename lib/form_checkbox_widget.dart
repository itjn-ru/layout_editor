import 'package:flutter/material.dart';
import 'package:layout_editor/component_widget.dart';

class FormCheckboxWidget extends ComponentWidget {
  FormCheckboxWidget(component) : super(component);

  @override
  Widget buildWidget(BuildContext context) {
    return const Checkbox(value: true, onChanged: null,);
  }
}
