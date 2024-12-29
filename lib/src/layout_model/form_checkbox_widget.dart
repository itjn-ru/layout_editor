import 'package:flutter/material.dart';
import 'component_widget.dart';
import 'style_element.dart';

class FormCheckboxWidget extends ComponentWidget {
  const FormCheckboxWidget(super.component, super.layoutModel, {super.key});

  @override
  Widget buildWidget(BuildContext context) {
    var style = StyleElement("стиль");
    final double fontSize= style['fontSize'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if(component.properties["text"]?.value != null)
          Expanded(
            child: Text('${component.properties["text"]?.value}: ',
              style: TextStyle(fontSize: fontSize),),
          ),
        const Checkbox(value: true, onChanged: null,),
      ],
    );
  }
}
