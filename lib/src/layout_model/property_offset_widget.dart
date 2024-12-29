import 'package:flutter/material.dart';
import 'property_widget.dart';

class PropertyOffsetWidget extends PropertyWidget {
  const PropertyOffsetWidget(super.property, super.layoutModel, {super.key});

  @override
  Widget buildWidget(BuildContext context, Function onChanged) {
    var controllerDx = TextEditingController();
    controllerDx.text = property.value.dx.toString();

    var controllerDy = TextEditingController();
    controllerDy.text = property.value.dy.toString();

    return Row(
      children: [
        const Text("Л: "),
        Expanded(
          child: TextField(
            controller: controllerDx,
            onChanged: (value) {
              property.value =
                  Offset(double.tryParse(value) ?? 0, property.value.dy);
            },
          ),
        ),
        const Text("В: "),
        Expanded(child: TextField(controller: controllerDy,
          onChanged: (value) {
            property.value =
                Offset(property.value.dx, double.tryParse(value) ?? 0);
          },)),
      ],
    );
  }
}
