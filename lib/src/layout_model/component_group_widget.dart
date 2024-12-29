import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'component.dart';
import 'component_widget.dart';

class ComponentGroupWidget extends ComponentWidget {
  const ComponentGroupWidget(super.component,super.layoutModel, {super.key});

  @override
  Widget buildWidget(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
        return ColoredBox(
          color: Colors.grey,
          child: Stack(
            children: List.generate(
              component.items.length,
              (index) => Positioned(
                 left: component.items[index]['position'].dx,
                top: component.items[index]['position'].dy,
                width: component.items[index]['size'].width,
                height: component.items[index]['size'].height,
               /* left: (component.items[index]['position'].dx/ 360) *
                  constraints.maxWidth,
                top: component.items[index]['position'].dy,
                width: (component.items[index]['size'].width / 360) *
                    constraints.maxWidth,
                height: component.items[index]['size'].height,*/
                child: ComponentWidget.create(
                    component.items[index] as LayoutComponent, layoutModel),
              ),
            ),
          ),
        );
      }
    );
  }
}
