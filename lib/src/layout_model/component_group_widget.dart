import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'canvas/layout_model_inherit.dart';
import 'canvas/resizable_draggable_widget.dart';
import 'component.dart';
import 'component_widget.dart';
import 'components_and_sources.dart';
import 'controller/layout_model_controller.dart';
import 'item.dart';

class ComponentGroupWidget extends ComponentWidget {
   const ComponentGroupWidget(super.component, super.controller,{super.key});

  @override
  Widget buildWidget(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final scale=ScreenSizeEnum.mobile.width/constraints.maxWidth;
      final List<Item> items=List.generate(component.items.length,  (index)=>
          component.items[index] );
        return SizedBox.fromSize(
          key: UniqueKey(),
          size: Size(component['size'].width/scale, component['size'].height/scale),
          child: ColoredBox(
            color: const Color(0xE3E3E3FF),
            child: GroupCanvas(component, scale, items: items, controller: controller),
          ),
        );
      }
    );
  }


}

class GroupCanvas extends StatelessWidget {
  final LayoutComponent component;
  final List<Item> items;
  final LayoutModelController controller;
  final double scale;
  const GroupCanvas(this.component, this.scale, {required this.items, required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: _initWidgetList(),
    );
  }
  List<LayoutModelInheritedWidget> _initWidgetList() {
    final List<LayoutModelInheritedWidget> _list = [];
    for (final itemChild in items) {
      _list.add(LayoutModelInheritedWidget(
        layoutModel: controller.layoutModel,
        child: ResizableDraggableWidget(
          //key: UniqueKey(),
          position: Offset(itemChild["position"]?.dx/scale  ?? 0,
              itemChild["position"]?.dy/scale  ?? 0),
          initWidth:
          itemChild["size"]?.width/scale,
          initHeight: itemChild["size"]?.height/scale ?? 50,
          canvasWidth: component['size'].width/scale,
          canvasHeight:  component['size'].height/scale,
          bgColor: Colors.white,
          squareColor: Colors.blueAccent,
          scaleConstraints: 1/scale,
          controller: controller,
          child: itemChild,
        ),
      ));
    }
    return _list;
  }
}
