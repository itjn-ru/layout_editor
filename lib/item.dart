import 'package:layout_editor/property.dart';

class Item {
  String type;
  List<Item> items = <Item>[];
  Map<String, Property> properties = {};

  Item(this.type, name) {
    properties["name"] = Property("имя", name);
  }

  operator [](String name) {
    return properties[name]?.value;
  }
}

