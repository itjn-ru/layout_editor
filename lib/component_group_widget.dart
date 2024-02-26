import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:layout_editor/component.dart';
import 'package:layout_editor/component_table.dart';
import 'package:layout_editor/component_widget.dart';
import 'package:layout_editor/item.dart';

class ComponentGroupWidget extends ComponentWidget {
  ComponentGroupWidget(component) : super(component);

  @override
  Widget buildWidget(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: Stack(
        children: List.generate(
          component.items.length,
          (index) => Positioned(
            left: component.items[index]["position"].dx,
            top: component.items[index]["position"].dy,
            width: component.items[index]["size"].width,
            height: component.items[index]["size"].height,
            child: ComponentWidget.create(
                component.items[index] as LayoutComponent),
          ),
        ),
      ),
    );
  }
}
