import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'property_widget.dart';
import 'style.dart';


class PropertyBorderStyleWidget extends PropertyWidget {
  const PropertyBorderStyleWidget(super.property, super.layoutModel, {super.key});

  @override
  Widget buildWidget(BuildContext context, Function onChanged) {
    final controllerWidth = TextEditingController();
    controllerWidth.text = property.value.width.toString();

    final List<CustomBorderSide> sides = CustomBorderSide.values;

    if (!sides.contains(property.value.side)) {
      property.value = CustomBorderSide.none;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Ширина: '),
            Expanded(
              child: TextField(
                controller: controllerWidth,
                onChanged: (value) {
                  property.value.width =
                      double.tryParse(value) ?? 0;
                },
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical:8),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: property.value.color),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Выберите цвет!'),
                    content: SingleChildScrollView(
                      child: BlockPicker(
                        pickerColor: property.value.color, //default color
                        onColorChanged: (Color color) {
                          property.value.color = color;
                          Navigator.of(context).pop();
                          onChanged();
                        },
                      ),
                    ),

                  );
                },
              );
            },
            child: const Text('цвет'),
          ),
        ),
        DropdownButton<CustomBorderSide>(
          value: property.value.side,
          isExpanded: true,
          items: sides
              .map<DropdownMenuItem<CustomBorderSide>>((e) => DropdownMenuItem(
            value: e,
            child: Text(e.title),
          ))
              .toList(),
          onChanged: (value) {
            property.value.side = value ?? CustomBorderSide.none;
            onChanged();
          },
        ),
      ],
    );
  }
}
