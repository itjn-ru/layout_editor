import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:layout_editor/property_widget.dart';

class PropertyUuidWidget extends PropertyWidget {
  PropertyUuidWidget(property) : super(property);

  @override
  Widget buildWidget(BuildContext context, Function onChanged) {


    return Text(property.value.toString());
  }
}
