import 'component.dart';
import 'custom_border_radius.dart';
import 'property.dart';
import 'style.dart';

class ComponentGroup extends LayoutComponent {
  ComponentGroup(name) : super("group", name) {
    properties["style"] = Property("стиль", Style.basic, type: Style);
    properties['borderRadius'] =
        Property('закругление', BorderRadiusNone, type: CustomBorderRadius);
  }
}
