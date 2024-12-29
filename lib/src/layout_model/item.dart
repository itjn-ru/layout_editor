import 'dart:ui';

import 'property.dart';
import 'style.dart';

class Item {
  String type;
  List<Item> items = <Item>[];
  Map<String, Property> properties = {};

  Item(this.type, name, [source]) {
    properties['name'] = Property('имя', name);
    properties['style'] = Property('стиль', Style.basic, type: Style);
  }

  dynamic operator [](String name) {
    return properties[name]?.value;
  }
}

/*class Pages{
  String type;
  List<Pages> items = <Pages>[];
  Map<String, Property> properties = {};

  Pages(this.type, name) {
    properties['name'] = Property('имя', name);

    properties['style'] = Property('стиль', Style.basic, type: Style);
  }

  dynamic operator [](String name) {
    return properties[name]?.value;
  }
}*/