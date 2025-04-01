import 'package:flutter/material.dart';
import 'component_widget.dart';

class FormRadioWidget extends ComponentWidget {
  const FormRadioWidget({required super.component,required super.controller,super.key, super.screenSize});

  @override
  Widget buildWidget(BuildContext context) {
    return const Radio(value: true, onChanged: null, groupValue: true,);
  }
}