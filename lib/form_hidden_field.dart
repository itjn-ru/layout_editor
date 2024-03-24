import 'package:layout_editor/component.dart';
import 'package:layout_editor/property.dart';
import 'package:uuid_type/uuid_type.dart';

class FormHiddenField extends LayoutComponent {
  FormHiddenField(name) : super("hiddenField", name) {
    properties["caption"] = Property("подпись", "");
    properties["id"] =
        Property("идентификатор", Uuid.parse(uuid.v4()), type: Uuid);
    properties["source"] = Property("источник", "");
  }
}
