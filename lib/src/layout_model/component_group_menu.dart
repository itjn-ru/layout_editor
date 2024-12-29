import 'package:flutter/material.dart';
import 'component_text.dart';
import 'form_checkbox.dart';
import 'form_text_field.dart';
import 'form_text_field.dart';
import 'menu.dart';
import 'component_table.dart';
import 'item.dart';
import 'page.dart';

import 'form_hidden_field.dart';
import 'form_radio.dart';
import 'form_slider_button.dart';

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
        child: Text("Добавить слайдер"),
        onTap: () {
          var item = FormSliderButton("слайдер");
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
      ),
    ];
  }
}