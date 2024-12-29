import 'package:flutter/widgets.dart';
import 'package:xml_edit/xml_edit.dart';
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
final LayoutModel layoutModel;
  const ComponentWidget(this.component,this.layoutModel, {super.key});

  factory ComponentWidget.create(LayoutComponent component,LayoutModel layoutModel) {
    switch (component.runtimeType) {
      case const (FormHiddenField):
        return FormHiddenFieldWidget(component,layoutModel);
      case const (FormRadio):
        return ComponentRadioWidget(component,layoutModel);
      case const (ComponentGroup):
        return ComponentGroupWidget(component,layoutModel);
      case const (ComponentText):
        return ComponentTextWidget(component,layoutModel);
      case const (ComponentTable):
        return ComponentTableWidget(component,layoutModel);
      case const (FormTextField):
        return FormTextFieldWidget(component,layoutModel);
      case const (FormImage):
        return FormImageWidget(component,layoutModel);
      case const (FormCheckbox):
        return FormCheckboxWidget(component,layoutModel);
      default:
        return ComponentWidget(component,layoutModel);
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
