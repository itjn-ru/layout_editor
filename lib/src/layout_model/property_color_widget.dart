import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:uuid/uuid.dart';
import 'controller/events.dart';
import 'property_widget.dart';

class PropertyColorWidget extends PropertyWidget {
  const PropertyColorWidget(super.controller, super.propertyKey, {super.key});

  @override
  Widget build(BuildContext context) {
    final property = controller.layoutModel.curItem.properties[propertyKey]!;
    return Row(children: [
      ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: property.value),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Pick a color!'),
                content: SingleChildScrollView(
                  child: BlockPicker(
                    pickerColor: property.value, //default color
                    onColorChanged: (Color color) {
                      //on color picked
                      //print(color);
                      property.value = color;
                      Navigator.of(context).pop();
                      controller.eventBus
                          .emit(ChangeItem(id: const Uuid().v4()));
                    },
                  ),
                ),
                /*actions: <Widget>[
                  ElevatedButton(
                    child: const Text('DONE'),
                    onPressed: () {
                      Navigator.of(context).pop(); //dismiss the color picker
                    },
                  ),
                ],*/
              );
            },
          );
        },
        child: const Text("Выбор цвета"),
      )
    ]);
  }
}
