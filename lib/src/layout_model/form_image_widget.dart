import 'package:flutter/material.dart';
import 'component_widget.dart';

class FormImageWidget extends ComponentWidget {
  const FormImageWidget({required super.component,required super.controller,super.key, super.screenSize});

  @override
  Widget buildWidget(BuildContext context) {
    return SizedBox(width: 300,
        height: 300,
        child: Image.memory(component.properties['Uint8List']?.value));
  }
}
