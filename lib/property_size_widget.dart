import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:layout_editor/property_widget.dart';

class PropertySizeWidget extends PropertyWidget {
  PropertySizeWidget(property) : super(property);

  @override
  Widget buildWidget(BuildContext context, Function onChanged) {
    var controllerWidth = TextEditingController();
    controllerWidth.text = property.value.width.toString();

    var controllerHeight = TextEditingController();
    controllerHeight.text = property.value.height.toString();

    return Row(
      children: [
        Text("Ш: "),
        Expanded(
          child: TextField(
            controller: controllerWidth,
            onChanged: (value) {
              property.value =
                  Size(double.tryParse(value) ?? 0, property.value.height);
            },
          ),
        ),
        Text("В: "),
        Expanded(
          child: TextField(
            controller: controllerHeight,
            onChanged: (value) {
              property.value =
                  Size(property.value.width, double.tryParse(value) ?? 0);
            },
          ),
        ),
      ],
    );
  }
}
