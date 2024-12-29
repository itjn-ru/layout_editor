import 'package:flutter/material.dart';
import 'package:xml_edit/src/layout_model/layout_model.dart';
import 'property.dart';
import 'property_widget.dart';

class Properties extends StatefulWidget {
  //final Map<String, Property> _properties;
  final LayoutModel layoutModel;

  const Properties(this.layoutModel, {super.key});

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
   _properties=widget.layoutModel.curItem.properties;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
   // var keys = widget.layoutModel.curItem.properties.keys;
    _properties=widget.layoutModel.curItem.properties;
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
              if (_properties[keys.elementAt(index)]?.title ==
                  'источник')
                DragTarget<String>(
                  builder: (
                    BuildContext context,
                    List<dynamic> accepted,
                    List<dynamic> rejected,
                  ) {
                    return PropertyWidget.create(
                        _properties[keys.elementAt(index)]!,widget.layoutModel);
                  },
                  onMove: (DragTargetDetails<String> details) {
                    setState(() {
                      dragging = true;
                    });
                  },
                  onLeave: (details) {
                    setState(() {
                      dragging = false;
                    });
                  },
                  onAcceptWithDetails: (DragTargetDetails<String> details) {
                    setState(() {
                      dragging = false;
                      _properties[keys.elementAt(index)]?.value =
                          details.data;
                    });
                  },
                )
              else
                PropertyWidget.create(
                    _properties[keys.elementAt(index)]!,widget.layoutModel),
            ]),
      ),
    );
  }
}
