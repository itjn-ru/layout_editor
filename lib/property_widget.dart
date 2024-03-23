import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:layout_editor/component.dart';
import 'package:layout_editor/component_table.dart';
import 'package:layout_editor/property.dart';
import 'package:layout_editor/property_alignment_widget.dart';
import 'package:layout_editor/property_color_widget.dart';
import 'package:layout_editor/property_font_weight_widget.dart';
import 'package:layout_editor/property_offset_widget.dart';
import 'package:layout_editor/property_size_widget.dart';
import 'package:layout_editor/property_text_style_widget.dart';
import 'package:layout_editor/property_uuid_widget.dart';
import 'package:uuid/uuid.dart';

import 'component_table_widget.dart';

class PropertyWidget extends StatefulWidget {
  final Property property;

  PropertyWidget(this.property);

  factory PropertyWidget.create(Property property) {
    switch (property.type) {
      case Offset:
        return PropertyOffsetWidget(property);
      case Size:
        return PropertySizeWidget(property);
      case Color:
        return PropertyColorWidget(property);
      case Alignment:
        return PropertyAlignmentWidget(property);
      case TextStyle:
        return PropertyTextStyleWidget(property);
      case FontWeight:
        return PropertyFontWeightWidget(property);
      case Uuid:
        return PropertyUuidWidget(property);
      default:
        return PropertyWidget(property);
    }
  }

  Widget buildWidget(BuildContext context, Function onChanged) {
    var controller = TextEditingController();
    controller.text = property.value.toString();
    return Row(children: [
      Expanded(
          child: TextField(
        controller: controller,
        onChanged: (value) {
          switch (property.type) {
            case double:
              property.value = double.tryParse(value);
            default:
              property.value = value;
          }
        },
      ))
    ]);
  }

  @override
  State<StatefulWidget> createState() {
    return _PropertyWidgetState();
  }
}

class _PropertyWidgetState extends State<PropertyWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.buildWidget(
        context,
        () {
          setState(() {});
        },
      ),
    );
  }

  onChanged() {
    setState(() {});
  }
}
