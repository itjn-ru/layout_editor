import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:layout_editor/component.dart';
import 'package:layout_editor/property.dart';

import 'item.dart';

class ComponentTable extends LayoutComponent {
  ComponentTable(name) : super("table", name) {
    items.add(ComponentTableColumn("колонка"));

    var row = ComponentTableRow("строка");
    row.items.add(ComponentTableCell("ячейка"));

    var rowGroup = ComponentTableRowGroup("группа строк");
    rowGroup.items.add(row);

    items.add(rowGroup);
  }
}

class ComponentTableColumn extends Item {
  ComponentTableColumn(name) : super("column", name) {
    properties["width"] = Property("ширина", 20, type: double);
  }
}

class ComponentTableRowGroup extends Item {
  ComponentTableRowGroup(name) : super("rowGroup", name);
}

class ComponentTableRow extends Item {
  ComponentTableRow(name) : super("row", name);
}

class ComponentTableCell extends Item {
  ComponentTableCell(name) : super("cell", name) {
    properties["text"] = Property("текст", "");
    properties["source"] = Property("источник", "");
    properties["color"] = Property("цвет", Colors.blue, type: Color);
    properties["alignment"] =
        Property("выравнивание", Alignment.centerLeft, type: Alignment);
    properties["textStyle"] = Property(
        "стиль текста",
        const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 11.0,
        ),
        type: TextStyle);
  }
}
