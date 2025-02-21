import 'package:flutter/material.dart';
import 'controller/layout_model_controller.dart';
import 'property.dart';
import 'property_widget.dart';

class Properties extends StatefulWidget {
  //final Map<String, Property> _properties;
  final LayoutModelController controller;

  const Properties(this.controller, {super.key});

  @override
  State<StatefulWidget> createState() {
    return PropertiesState();
  }
}

class PropertiesState extends State<Properties> {
  bool dragging = false;
late Map<String, Property> _properties;
 @override
  void initState() {
   _properties=widget.controller.layoutModel.curItem.properties;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
   // var keys = widget.layoutModel.curItem.properties.keys;
    _properties=widget.controller.layoutModel.curItem.properties;
   var keys = _properties.keys;

    return Table(
      columnWidths: const {0: FixedColumnWidth(50), 1: FixedColumnWidth(100)},
      children: List.generate(
        keys.length,
        (index) => TableRow(
            decoration: BoxDecoration(
                color: dragging ? Colors.greenAccent : Colors.transparent,
                border: const Border(
                    bottom: BorderSide(color: Colors.black, width: 1))),
            children: [
              Text(
                  "${_properties[keys.elementAt(index)]?.title ?? ""}:"),
                PropertyWidget.create(
                    widget.controller,keys.elementAt(index)),
                    //_properties[keys.elementAt(index)]!,widget.controller),
            ]),
      ),
    );
  }
}
