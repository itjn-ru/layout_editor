import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'controller/events.dart';
import 'controller/layout_model_controller.dart';
import 'custom_border_radius.dart';
import 'property_alignment_widget.dart';
import 'property_border_radius_widget.dart';
import 'property_color_widget.dart';
import 'property_font_weight_widget.dart';
import 'property_image_widget.dart';
import 'property_offset_widget.dart';
import 'property_size_widget.dart';
import 'property_style_widget.dart';
import 'property_uuid_widget.dart';
import 'package:uuid/uuid.dart';
import 'style.dart';
import 'property_border_style_widget.dart';

class PropertyWidget extends StatelessWidget {
  final String propertyKey;
final LayoutModelController controller;
  const PropertyWidget(this.controller, this.propertyKey, {super.key});

  factory PropertyWidget.create(LayoutModelController controller, String propertyKey) {
    switch (controller.layoutModel.curItem.properties[propertyKey]?.type) {
      case const (CustomBorderRadius):
        return PropertyBorderRadiusWidget(controller,propertyKey);
      // case const (CustomBorderStyle):
      //   return PropertyBorderStyleWidget(controller,propertyKey);
      case const (Offset):
        return PropertyOffsetWidget(controller,propertyKey);
      case const (Size) :
        return PropertySizeWidget(controller,propertyKey);
      case const (Color):
        return PropertyColorWidget(controller,propertyKey);
      case const (Alignment):
        return PropertyAlignmentWidget(controller,propertyKey);
      case const (Style):
        return PropertyStyleWidget(controller,propertyKey);
      case const (FontWeight):
        return PropertyFontWeightWidget(controller,propertyKey);
      case const (UuidValue):
        return PropertyUuidWidget(controller,propertyKey);
      case const (Uint8List):
        return PropertyImageWidget(controller,propertyKey);
      default:
        return PropertyWidget(controller,propertyKey);
    }
  }


  @override
  Widget build(BuildContext context) {
    final property = controller.layoutModel.curItem.properties[propertyKey]!;
    final txtController = TextEditingController();
    txtController.text = property.value.toString();
    txtController.selection = TextSelection.fromPosition(TextPosition(offset: txtController.text.length));
    return Row(children: [
      Expanded(
          child: TextField(
            controller: txtController,
            focusNode: FocusNode(),
            onTap: ()=>controller.eventBus.emit(ChangeItem(id: const Uuid().v4())),
            onSubmitted: (value)=> controller.eventBus.emit(ChangeItem(id: const Uuid().v4())),
            onTapOutside: (value)=> controller.eventBus.emit(ChangeItem(id: const Uuid().v4())),
            onEditingComplete:()=> controller.eventBus.emit(ChangeItem(id: const Uuid().v4())),
            onChanged: (value) {
              switch (property.type) {
                case const (double):
                  property.value = double.tryParse(value);
                default:
                  property.value = value;
              }

            },
          ))
    ]);
  }
}
