import '/src/layout_model/property.dart';

import 'item.dart';

class Root extends Item {
  Root(name) : super("root", name) {
    properties['link'] = Property('ссылка', 'ссылка');
  }
}
