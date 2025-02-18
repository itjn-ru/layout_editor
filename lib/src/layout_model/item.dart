import 'dart:ui';

import 'package:uuid/uuid.dart';

import 'property.dart';
import 'style.dart';

class Item {
  String type;
  String? _id;
  List<Item> items = <Item>[];
  Map<String, Property> properties = {};

  Item(this.type, name, [source]) {
    properties['id']=Property('идентификатор', _id??const Uuid().v4());
    properties['name'] = Property('имя', name);
    properties['style'] = Property('стиль', Style.basic, type: Style);
  }

  dynamic operator [](String name) {
    return properties[name]?.value;
  }

  String get id=>properties['id']?.value??'';
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