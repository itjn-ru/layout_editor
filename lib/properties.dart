import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:layout_editor/property.dart';
import 'package:layout_editor/property_widget.dart';

class Properties extends StatefulWidget {
  final Map<String, Property> _properties;

  const Properties(this._properties, {super.key});

  @override
  State<StatefulWidget> createState() {
    return PropertiesState();
  }
}

class PropertiesState extends State<Properties> {
  @override
  Widget build(BuildContext context) {
    var keys = widget._properties.keys;

    return Container(
           child: Table(
        columnWidths: const {0: FixedColumnWidth(50), 1: FixedColumnWidth(100)},
        children: List.generate(
          keys.length,
          (index) => TableRow(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.black, width: 1))),
              children: [
                Text((widget._properties[keys.elementAt(index)]?.title ?? "") +
                    ":"),
                Container(
                    child: PropertyWidget.create(
                        widget._properties[keys.elementAt(index)]!)),
              ]),
        ),
      ),
    );
  }
}
