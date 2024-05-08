import 'package:flutter/material.dart';
import 'package:layout_editor/component_widget.dart';

class FormRadioWidget extends ComponentWidget {
  FormRadioWidget(component) : super(component);

  @override
  Widget buildWidget(BuildContext context) {
    return const Radio(value: true, onChanged: null, groupValue: true,);
  }
}
