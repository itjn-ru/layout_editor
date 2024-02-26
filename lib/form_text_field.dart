import 'package:layout_editor/component.dart';
import 'package:layout_editor/property.dart';

class FormTextField extends LayoutComponent {
  FormTextField(name) : super("textField", name) {
    properties["caption"] = Property("подпись", "");
    properties["source"] = Property("источник", "");
  }



}
