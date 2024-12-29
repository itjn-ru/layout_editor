import 'package:flutter/material.dart';
import 'property_widget.dart';

class PropertyUuidWidget extends PropertyWidget {
  const PropertyUuidWidget(super.property, super.layoutModel, {super.key});

  @override
  Widget buildWidget(BuildContext context, Function onChanged) {


    return Text(property.value.toString());
  }
}
