import 'package:flutter/material.dart';
import 'property_widget.dart';

class PropertyFontWeightWidget extends PropertyWidget {
  const PropertyFontWeightWidget(super.property, super.layoutModel, {super.key});

  @override
  Widget buildWidget(BuildContext context, Function onChanged) {

    return Row(children: [

      Expanded(
        child: DropdownButton<FontWeight>(
          value: property.value,
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
            property.value = value ?? FontWeight.normal;
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
    ]);
  }
}
