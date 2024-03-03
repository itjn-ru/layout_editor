import 'package:layout_editor/component.dart';
import 'package:layout_editor/property.dart';

class FormHiddenField extends LayoutComponent {
  FormHiddenField(name) : super("hiddenField", name) {
    properties["caption"] = Property("подпись", "");
    properties["source"] = Property("источник", "");
  }



}
