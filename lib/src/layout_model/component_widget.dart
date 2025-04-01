import 'package:admin_layout_editor/src/layout_model/screen_size_enum.dart';
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
final ScreenSizeEnum? screenSize;

  const ComponentWidget({super.key, required this.component, required this.controller, this.screenSize=ScreenSizeEnum.mobile});

  factory ComponentWidget.create(LayoutComponent component, LayoutModelController controller, [ScreenSizeEnum? screenSize] ) {
    switch (component.runtimeType) {
      case const (FormHiddenField):
        return FormHiddenFieldWidget(component: component, controller: controller,screenSize: screenSize??ScreenSizeEnum.mobile);
      case const (FormRadio):
        return ComponentRadioWidget(component: component, controller: controller,screenSize: screenSize??ScreenSizeEnum.mobile);
      case const (ComponentGroup):
        return ComponentGroupWidget(component: component, controller: controller,screenSize: screenSize??ScreenSizeEnum.mobile);
      case const (ComponentText):
        return ComponentTextWidget(component: component, controller: controller,screenSize: screenSize??ScreenSizeEnum.mobile);
      case const (ComponentTable):
        return ComponentTableWidget(component: component, controller: controller,screenSize: screenSize??ScreenSizeEnum.mobile);
      case const (FormTextField):
        return FormTextFieldWidget(component: component, controller: controller,screenSize: screenSize??ScreenSizeEnum.mobile);
      case const (FormImage):
        return FormImageWidget(component: component, controller: controller,screenSize: screenSize??ScreenSizeEnum.mobile);
      case const (FormCheckbox):
        return FormCheckboxWidget(component: component, controller: controller,screenSize: screenSize??ScreenSizeEnum.mobile);
      default:
        return ComponentWidget(component: component, controller: controller,screenSize: screenSize??ScreenSizeEnum.mobile);
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
