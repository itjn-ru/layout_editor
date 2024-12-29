import 'package:flutter/material.dart';
import 'property_widget.dart';

class PropertySizeWidget extends PropertyWidget {
  const PropertySizeWidget(super.property, super.layoutModel, {super.key});

  @override
  Widget buildWidget(BuildContext context, Function onChanged) {
    var controllerWidth = TextEditingController();
    controllerWidth.text = property.value.width.toString();

    var controllerHeight = TextEditingController();
    controllerHeight.text = property.value.height.toString();

    return Row(
      children: [
        const Text("Ш: "),
        Expanded(
          child: TextField(
            controller: controllerWidth,
            onChanged: (value) {
              property.value =
                  Size(double.tryParse(value) ?? 0, property.value.height);
            },
          ),
        ),
        const Text("В: "),
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
