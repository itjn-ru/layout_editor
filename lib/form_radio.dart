import 'package:layout_editor/component.dart';
import 'package:layout_editor/property.dart';


class FormRadio extends LayoutComponent {
  FormRadio(name) : super("radio", name) {
    properties["text"] = Property("текст", "");
    properties["source"] = Property("источник", "");
  }



}
