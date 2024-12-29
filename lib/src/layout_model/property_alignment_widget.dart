import 'package:flutter/material.dart';
import 'property_widget.dart';

class PropertyAlignmentWidget extends PropertyWidget {
  const PropertyAlignmentWidget(super.property, super.layoutModel, {super.key});

  @override
  Widget buildWidget(BuildContext context, Function onChanged) {
    return Row(
      children: [
        Expanded(
          child: DropdownButton<Alignment>(
            value: property.value,
            isExpanded: true,
            items: [
              Alignment.topLeft,
              Alignment.topCenter,
              Alignment.topRight,
              Alignment.centerLeft,
              Alignment.center,
              Alignment.centerRight,
              Alignment.bottomLeft,
              Alignment.bottomCenter,
              Alignment.bottomRight
            ]
                .map<DropdownMenuItem<Alignment>>(
                    (alignment) => DropdownMenuItem(
                          value: alignment,
                          child: Text(switch (alignment) {
                            Alignment.topLeft => "вверху слева",
                            Alignment.topCenter => "вверху по центру",
                            Alignment.topRight => "вверху справа",
                            Alignment.centerLeft => "по центру слева",
                            Alignment.center => "по центру",
                            Alignment.centerRight => "по центру справа",
                            Alignment.bottomLeft => "внизу слева",
                            Alignment.bottomCenter => "внизу по центру",
                            Alignment.bottomRight => "внизу справа",
                            _ => "",
                          }),
                        ))
                .toList(),
            onChanged: (Object? value) {
              property.value = value;
              onChanged();
            },
          ),
        ),
      ],
    );
  }
}
