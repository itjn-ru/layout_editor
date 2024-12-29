import 'package:flutter/material.dart';
import 'component.dart';
import 'component_group.dart';
import 'component_table_menu.dart';
import 'component_text.dart';
import 'form_checkbox.dart';
import 'form_checkbox_menu.dart';
import 'form_hidden_field.dart';
import 'form_hidden_field_menu.dart';
import 'form_image_menu.dart';
import 'form_slider_button.dart';
import 'form_slider_button_menu.dart';
import 'item.dart';
import 'layout_model.dart';
import 'page.dart';
import 'process.dart';
import 'process_element.dart';
import 'process_item_menu.dart';
import 'process_page_menu.dart';
import 'style.dart';
import 'style_element.dart';
import 'style_element_menu.dart';
import 'style_page_menu.dart';
import 'root.dart';
import 'source.dart';
import 'source_page_menu.dart';
import 'source_table.dart';
import 'source_table_menu.dart';
import 'source_variable.dart';
import 'source_variable_menu.dart';
import 'component_group_menu.dart';
import 'component_page_menu.dart';
import 'component_root_menu.dart';
import 'component_table.dart';
import 'component_text_menu.dart';
import 'form_image.dart';
import 'form_radio.dart';
import 'form_radio_menu.dart';
import 'form_text_field.dart';
import 'form_text_field_menu.dart';

class FAB extends StatelessWidget {
  final Function(Item?)? onChanged;
final LayoutModel layoutModel;
  const FAB({this.onChanged, required this.layoutModel, super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.edit),
      onPressed: () {
        var keyContext = (key as GlobalKey).currentContext;

        var menu =
            ComponentAndSourceMenu.create(layoutModel, layoutModel.curItem);

        var menuItems = menu.getComponentMenu(onChanged);

        if (menuItems.isEmpty) {
          return;
        }

        RenderBox renderBox = keyContext?.findRenderObject() as RenderBox;
        RenderBox overlay =
            Overlay.of(keyContext!).context.findRenderObject() as RenderBox;

        showMenu(
            context: keyContext,
            position: _buttonMenuPosition(
                renderBox, overlay), //RelativeRect.fromLTRB(0, 0, 0, 0),
            items: menuItems);
      },
    );
  }

  RelativeRect _buttonMenuPosition(RenderBox renderBox, RenderBox overlay) {
    //RenderBox renderBox = keyContext.findRenderObject() as RenderBox;
    //RenderBox overlay = Overlay.of(keyContext).context.findRenderObject() as RenderBox;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        renderBox.localToGlobal(renderBox.size.bottomLeft(Offset.zero),
            ancestor: overlay),
        renderBox.localToGlobal(renderBox.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    return position;
  }
}

class ComponentAndSourceMenu {
  LayoutModel layoutModel;
  Item target;

  void Function(Item?)? onChanged;
  void Function(Item?)? onDeleted;

  ComponentAndSourceMenu(this.layoutModel, this.target,
      {this.onChanged, this.onDeleted});

  factory ComponentAndSourceMenu.create(LayoutModel layoutModel, Item target,
      {void Function(Item?)? onChanged, Function(Item?)? onDeleted}) {
    if (target is Root) {
      return ComponentRootMenu(layoutModel, target, onChanged: onChanged);
    } else if (target is ComponentPage) {
      return ComponentPageMenu(layoutModel, target, onChanged: onChanged);
    } else if (target is ComponentGroup) {
      return ComponentGroupMenu(layoutModel, target, onChanged: onChanged);
    } else if (target is SourcePage) {
      return SourcePageMenu(layoutModel, target, onChanged: onChanged);
    } else if (target is StylePage) {
      return StylePageMenu(layoutModel, target, onChanged: onChanged);
    } else if (target is ProcessPage) {
      return ProcessPageMenu(layoutModel, target, onChanged: onChanged);
    }else if (target is LayoutComponent ||
        target is LayoutSource ||
        target is LayoutStyle ||
        target is LayoutProcess) {
      switch (target.runtimeType) {
        case ComponentTable:
          return ComponentTableMenu(layoutModel, target,
              onChanged: onChanged, onDeleted: onDeleted);
        case ComponentText:
          return ComponentTextMenu(layoutModel, target, onChanged: onChanged);
        case FormImage:
          return FormImageMenu(layoutModel, target,
              onChanged: onChanged);
        case FormSliderButton:
          return FormSliderButtonMenu(layoutModel, target,
              onChanged: onChanged);
        case FormRadio:
          return FormRadioMenu(layoutModel, target, onChanged: onChanged);
        case FormCheckbox:
          return FormCheckboxMenu(layoutModel, target, onChanged: onChanged);
        case FormHiddenField:
          return FormHiddenFieldMenu(layoutModel, target, onChanged: onChanged);
        case FormTextField:
          return FormTextFieldMenu(layoutModel, target, onChanged: onChanged);
        case SourceVariable:
          return SourceVariableMenu(layoutModel, target, onChanged: onChanged);
        case StyleElement:
          return StyleElementMenu(layoutModel, target, onChanged: onChanged);
        case ProcessElement:
          return ProcessItemMenu(layoutModel, target, onChanged: onChanged);
        case SourceTable:
          return SourceTableMenu(layoutModel, target,
              onChanged: onChanged, onDeleted: onDeleted);
        default:
          return ComponentAndSourceMenu(layoutModel, target,
              onChanged: onChanged);
      }
    } else {
      var component = layoutModel.getComponentByItem(target);

      if (/*layoutModel.curC*/ component == null) {
        return ComponentAndSourceMenu(layoutModel, target,
            onChanged: onChanged);
      }

      switch (/*layoutModel.curC*/ component.runtimeType) {
        case ComponentTable:
          return ComponentTableMenu(layoutModel, target,
              onChanged: onChanged, onDeleted: onDeleted);
        case SourceTable:
          return SourceTableMenu(layoutModel, target,
              onChanged: onChanged, onDeleted: onDeleted);
        default:
          return ComponentAndSourceMenu(layoutModel, target,
              onChanged: onChanged);
      }
    }
  }

  List<PopupMenuEntry> getComponentMenu(Function(Item?)? onChanged) {
    return [];
  }
}
