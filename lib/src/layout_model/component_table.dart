import 'component.dart';
import 'property.dart';
import 'style.dart';
import 'item.dart';

class ComponentTable extends LayoutComponent {
  ComponentTable(name) : super("table", name) {
    properties['source'] = Property('источник', '');
    items.add(ComponentTableColumn("колонка"));

    var row = ComponentTableRow("строка");
    row.items.add(ComponentTableCell("ячейка",''));

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
  ComponentTableRowGroup(name) : super("rowGroup", name) {
    properties["style"] = Property("стиль", Style.basic, type: Style);
  }
}


class ComponentTableRow extends Item {
  ComponentTableRow(name) : super("row", name) {
    properties["style"] = Property("стиль", Style.basic, type: Style);
    properties["height"] = Property("высота", 20, type: double);

  }
}

class ComponentTableCell extends Item {
  ComponentTableCell(name,source) : super("cell", name,source) {
    properties["text"] = Property("текст", "");
    properties["source"] = Property("источник", source??"");
    properties["style"] = Property("стиль", Style.basic, type: Style);
    properties["colspan"] = Property("объединения колонок", 0,type: int);
    properties["rowspan"] = Property(" объединения строк", 0,type: int);
    properties["stylefontSize"] = Property("размер шрифта", 9.0,type: double);
    properties["verticalAlignment"] = Property("вертикальное выравнивание", 1.0,type: double);
    properties["horizontalAlignment"] = Property("горизонтальное выравнивание", -1.0,type: double);
    properties["topBorder"] = Property("верхняя граница", CustomBorderStyle.init(),type: CustomBorderStyle);
    properties["leftBorder"] = Property("левая граница", CustomBorderStyle.init(),type: CustomBorderStyle);
    properties["rightBorder"] = Property("правая граница", CustomBorderStyle.init(),type: CustomBorderStyle);
    properties["bottomBorder"] = Property("нижняя граница", CustomBorderStyle.init(),type: CustomBorderStyle);
    properties["isItalic"] = Property("наклонный шрифт", false,type: bool);
  }
}


