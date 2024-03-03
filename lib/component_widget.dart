import 'package:flutter/widgets.dart';
import 'package:layout_editor/component.dart';
import 'package:layout_editor/component_table.dart';
import 'package:layout_editor/component_text.dart';
import 'package:layout_editor/form_checkbox.dart';
import 'package:layout_editor/form_checkbox_widget.dart';
import 'package:layout_editor/form_hidden_field.dart';
import 'package:layout_editor/form_text_field.dart';

import 'component_group.dart';
import 'component_group_widget.dart';
import 'component_table_widget.dart';
import 'component_text_widget.dart';
import 'form_hidden_field_widget.dart';
import 'form_text_field_widget.dart';

class ComponentWidget extends StatelessWidget {
  final LayoutComponent component;

  ComponentWidget(this.component);

  factory ComponentWidget.create(LayoutComponent component) {
    switch (component.runtimeType) {
      case ComponentGroup:
        return ComponentGroupWidget(component);
      case ComponentText:
        return ComponentTextWidget(component);
      case ComponentTable:
        return ComponentTableWidget(component);
      case FormTextField:
        return FormTextFieldWidget(component);
      case FormCheckbox:
        return FormCheckboxWidget(component);
      case FormHiddenField:
        return FormHiddenFieldWidget(component);
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
