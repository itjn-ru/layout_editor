import 'package:layout_editor/property.dart';
import 'package:uuid/uuid.dart';
import 'component_and_source.dart';

class LayoutStyle extends LayoutComponentAndSource {
  LayoutStyle(super.type, super.name) {
    properties["id"] = Property("идентификатор", const Uuid().v4(), type: Uuid);
  }
}

class Style{}