import 'package:uuid_type/uuid_type.dart';
import 'component_and_source.dart';

class LayoutStyle extends LayoutComponentAndSource {
  LayoutStyle(super.type, super.name);
}

class Style {
  Uuid id;
  String name;

  static Style basic = Style(Uuid.nil, "базовый стиль");

  Style(this.id, this.name);


  @override
  bool operator == (Object other) =>
      other is Style && id == other.id;

  @override
  int get hashCode => Object.hash(id, name);

}
