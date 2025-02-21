import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'controller/events.dart';
import 'property_widget.dart';

class PropertyOffsetWidget extends PropertyWidget {
  const PropertyOffsetWidget(super.controller, super.propertyKey, {super.key});

  @override
  Widget build(BuildContext context) {
    final property = controller.layoutModel.curItem.properties[propertyKey]!;
    var controllerDx = TextEditingController();
    controllerDx.text = property.value.dx.toString();

    var controllerDy = TextEditingController();
    controllerDy.text = property.value.dy.toString();

    return Row(
      children: [
        const Text("Л: "),
        Expanded(
          child: TextField(
            controller: controllerDx,
            focusNode: FocusNode(),
            onTap: () =>
                controller.eventBus.emit(ChangeItem(id: const Uuid().v4())),
            onSubmitted: (value) =>
                controller.eventBus.emit(ChangeItem(id: const Uuid().v4())),
            onTapOutside: (value) =>
                controller.eventBus.emit(ChangeItem(id: const Uuid().v4())),
            onEditingComplete: () =>
                controller.eventBus.emit(ChangeItem(id: const Uuid().v4())),
            onChanged: (value) {
              property.value =
                  Offset(double.tryParse(value) ?? 0, property.value.dy);
            },
          ),
        ),
        const Text("В: "),
        Expanded(
            child: TextField(
          controller: controllerDy,
              focusNode: FocusNode(),
          onTap: () =>
              controller.eventBus.emit(ChangeItem(id: const Uuid().v4())),
          onSubmitted: (value) =>
              controller.eventBus.emit(ChangeItem(id: const Uuid().v4())),
          onTapOutside: (value) =>
              controller.eventBus.emit(ChangeItem(id: const Uuid().v4())),
          onEditingComplete: () =>
              controller.eventBus.emit(ChangeItem(id: const Uuid().v4())),
          onChanged: (value) {
            property.value =
                Offset(property.value.dx, double.tryParse(value) ?? 0);
          },
        )),
      ],
    );
  }
}
