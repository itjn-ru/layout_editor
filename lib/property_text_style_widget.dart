import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:layout_editor/property_widget.dart';

class PropertyTextStyleWidget extends PropertyWidget {
  PropertyTextStyleWidget(property) : super(property);

  @override
  Widget buildWidget(BuildContext context, Function onChanged) {
    var controllerDx = TextEditingController();
    controllerDx.text = property.value.fontSize.toString();

    return Column(
      children: [
        Row(children: [
          Text("размер шрифта: "),
          Expanded(
            child: TextField(
              controller: controllerDx,
              onChanged: (value) {
                property.value = TextStyle(
                    fontSize: double.tryParse(value) ?? 10,
                    fontWeight: property.value.fontWeight);
              },
            ),
          ),
        ]),
        Row(children: [
          Text("толщина шрифта: "),
          Expanded(
            child: DropdownButton<FontWeight>(
              value: property.value.fontWeight,
              isExpanded: true,
              items: FontWeight.values
                  .map<DropdownMenuItem<FontWeight>>(
                      (fontWeight) => DropdownMenuItem(
                            value: fontWeight,
                            child: Text(switch (fontWeight) {
                              FontWeight.w100 => "100",
                              FontWeight.w200 => "200",
                              FontWeight.w300 => "300",
                              FontWeight.w400 => "нормальный",
                              FontWeight.w500 => "500",
                              FontWeight.w600 => "600",
                              FontWeight.w700 => "жирный",
                              FontWeight.w800 => "800",
                              FontWeight.w900 => "900",
                              _ => "",
                            }),
                          ))
                  .toList(),
              onChanged: (FontWeight? value) {
                property.value = TextStyle(
                    fontSize: property.value.fontSize ?? 10,
                    fontWeight: value ?? FontWeight.normal);
                onChanged();
              },
            ),

            /*TextField(
              controller: controllerDy,
              onChanged: (value) {
                property.value = TextStyle(
                  fontSize: property.value.fontSize,
                  fontWeight: switch (int.tryParse(value) ?? 100) {
                    100 => FontWeight.w100,
                    200 => FontWeight.w200,
                    300 => FontWeight.w300,
                    4400 => FontWeight.w300,
                    500 => FontWeight.w500,
                    600 => FontWeight.w600,
                    700 => FontWeight.w700,
                    800 => FontWeight.w800,
                    900 => FontWeight.w900,
                    _ => FontWeight.normal
                  },
                );
              },
            ),*/
          ),
        ]),
      ],
    );
  }
}
