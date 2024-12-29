import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:xml_edit/src/layout_model/layout_model.dart';
import 'property.dart';
import 'property_alignment_widget.dart';
import 'property_color_widget.dart';
import 'property_font_weight_widget.dart';
import 'property_image_widget.dart';
import 'property_offset_widget.dart';
import 'property_size_widget.dart';
import 'property_style_widget.dart';
import 'property_uuid_widget.dart';
import 'style.dart';
import 'package:uuid/uuid.dart';

import 'property_border_style_widget.dart';

class PropertyWidget extends StatefulWidget {
  final Property property;
final LayoutModel layoutModel;
  const PropertyWidget(this.property, this.layoutModel, {super.key});

  factory PropertyWidget.create(Property property, LayoutModel layoutModel) {
    switch (property.type) {
      case const (CustomBorderStyle):
        return PropertyBorderStyleWidget(property,layoutModel);
      case const (Offset):
        return PropertyOffsetWidget(property,layoutModel);
      case Size _:
        return PropertySizeWidget(property,layoutModel);
      case Color:
        return PropertyColorWidget(property,layoutModel);
      case Alignment:
        return PropertyAlignmentWidget(property,layoutModel);
      case Style:
        return PropertyStyleWidget(property,layoutModel);
      case FontWeight:
        return PropertyFontWeightWidget(property,layoutModel);
      case UuidValue:
        return PropertyUuidWidget(property,layoutModel);
      case Uint8List:
        return PropertyImageWidget(property,layoutModel);
      default:
        return PropertyWidget(property,layoutModel);
    }
  }

  Widget buildWidget(BuildContext context, Function onChanged) {
    final controller = TextEditingController();
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
