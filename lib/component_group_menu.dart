import 'package:flutter/material.dart';
import 'package:layout_editor/component_text.dart';
import 'package:layout_editor/form_checkbox.dart';
import 'package:layout_editor/form_text_field.dart';
import 'package:layout_editor/menu.dart';
import 'package:layout_editor/component_table.dart';
import 'package:layout_editor/item.dart';
import 'package:layout_editor/page.dart';
import 'package:layout_editor/root.dart';
import 'package:layout_editor/source_table.dart';

import 'component_group.dart';
import 'form_hidden_field.dart';
import 'form_radio.dart';

class ComponentGroupMenu extends ComponentAndSourceMenu {
  ComponentGroupMenu(super.layoutModel, super.target, {super.onChanged});

  @override
  List<PopupMenuEntry<Item>> getComponentMenu(void Function(Item)? onChanged) {
    var pageCount = layoutModel.root.items
        .where((element) => element.runtimeType == ComponentPage)
        .length;

    return [
      PopupMenuItem(
        child: Text("Добавить текст"),
        onTap: () {
          var item = ComponentText("текст");
          layoutModel.addItem(target, item);
          onChanged!(item);
        },
      ),
      PopupMenuItem(
        child: Text("Добавить таблицу"),
        onTap: () {
          var item = ComponentTable("таблица");
          layoutModel.addItem(target, item);
          onChanged!(item);
        },
      ),
      PopupMenuItem(
        child: Text("Добавить текстовое поле"),
        onTap: () {
          var item = FormTextField("текстовое поле");
          layoutModel.addItem(target, item);
          onChanged!(item);
        },
      ),
      PopupMenuItem(
        child: Text("Добавить радиокнопку"),
        onTap: () {
          var item = FormRadio("радиокнопка");
          layoutModel.addItem(target, item);
          onChanged!(item);
        },
      ),
      PopupMenuItem(
        child: Text("Добавить флажок"),
        onTap: () {
          var item = FormCheckbox("флажок");
          layoutModel.addItem(target, item);
          onChanged!(item);
        },
      ),
      PopupMenuItem(
        child: Text("Добавить скрытое поле"),
        onTap: () {
          var item = FormHiddenField("скрытое поле");
          layoutModel.addItem(target, item);
          onChanged!(item);
        },
      ),
      PopupMenuItem(
        child: Text("Удалить группу"),
        onTap: () {
          layoutModel.deleteItem(layoutModel.curItem);

          onChanged!(layoutModel.curItem);
        },
      )
    ];
  }
}
