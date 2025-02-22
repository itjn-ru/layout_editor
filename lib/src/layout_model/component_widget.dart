import 'package:flutter/widgets.dart';
import 'component.dart';
import 'component_radio_widget.dart';
import 'component_table.dart';
import 'component_text.dart';
import 'controller/layout_model_controller.dart';
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
final LayoutModelController controller;
  const ComponentWidget(this.component, this.controller, {super.key});

  factory ComponentWidget.create(LayoutComponent component, LayoutModelController controller) {
    switch (component.runtimeType) {
      case const (FormHiddenField):
        return FormHiddenFieldWidget(component, controller);
      case const (FormRadio):
        return ComponentRadioWidget(component, controller);
      case const (ComponentGroup):
        return ComponentGroupWidget(component, controller);
      case const (ComponentText):
        return ComponentTextWidget(component, controller);
      case const (ComponentTable):
        return ComponentTableWidget(component, controller);
      case const (FormTextField):
        return FormTextFieldWidget(component, controller);
      case const (FormImage):
        return FormImageWidget(component, controller);
      case const (FormCheckbox):
        return FormCheckboxWidget(component, controller);
      default:
        return ComponentWidget(component, controller);
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
