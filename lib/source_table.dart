import 'package:layout_editor/item.dart';
import 'package:layout_editor/property.dart';
import 'package:layout_editor/source.dart';

class SourceTable extends LayoutSource {
  SourceTable(name) : super("table", name) {
    items.add(SourceTableColumn("колонка"));

  }
}

class SourceTableColumn extends Item {
  SourceTableColumn(name) : super("column", name) {
    //properties["width"] = Property("ширина", 20, type: double);
  }
}