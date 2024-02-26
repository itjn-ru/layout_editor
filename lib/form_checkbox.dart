import 'package:layout_editor/component.dart';
import 'package:layout_editor/property.dart';


class FormCheckbox extends LayoutComponent {
  FormCheckbox(name) : super("checkbox", name) {
    properties["text"] = Property("текст", "");
    properties["source"] = Property("источник", "");
  }



}
