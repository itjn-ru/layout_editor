import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'property_widget.dart';

class PropertyColorWidget extends PropertyWidget {
  const PropertyColorWidget(super.property, super.layoutModel, {super.key});

  @override
  Widget buildWidget(BuildContext context, Function onChanged) {
    return Row(children: [
      ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: property.value),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Pick a color!'),
                content: SingleChildScrollView(
                  child: BlockPicker(
                    pickerColor: property.value, //default color
                    onColorChanged: (Color color) {
                      //on color picked
                      //print(color);
                      property.value = color;
                      Navigator.of(context).pop();
                      onChanged();
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
        child: Text("Выбор цвета"),
      )
    ]);
  }
}
