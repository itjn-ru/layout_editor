import 'package:flutter/widgets.dart';
import '../../admin_layout_editor.dart';
import 'component.dart';
import 'component_radio_widget.dart';
import 'component_table.dart';
import 'component_text.dart';
import 'form_checkbox.dart';
import 'form_checkbox_widget.dart';
import 'form_hidden_field.dart';
import 'form_image.dart';
import 'form_image_widget.dart';
import 'form_radio.dart';
import 'form_text_field.dart';
import 'component_group.dart';
import 'component_group_widget.dart';
import 'component_table_widget.dart';
import 'component_text_widget.dart';
import 'form_hidden_field_widget.dart';
import 'form_text_field_widget.dart';

class ComponentWidget extends StatelessWidget {
  final LayoutComponent component;

  const ComponentWidget(this.component, {super.key});

  factory ComponentWidget.create(LayoutComponent component) {
    switch (component.runtimeType) {
      case const (FormHiddenField):
        return FormHiddenFieldWidget(component);
      case const (FormRadio):
        return ComponentRadioWidget(component);
      case const (ComponentGroup):
        return ComponentGroupWidget(component);
      case const (ComponentText):
        return ComponentTextWidget(component);
      case const (ComponentTable):
        return ComponentTableWidget(component);
      case const (FormTextField):
        return FormTextFieldWidget(component);
      case const (FormImage):
        return FormImageWidget(component);
      case const (FormCheckbox):
        return FormCheckboxWidget(component);
      default:
        return ComponentWidget(component);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: buildWidget(context),
    );
  }

  Widget buildWidget(BuildContext context) {
    return Text(component.type);
  }
}
