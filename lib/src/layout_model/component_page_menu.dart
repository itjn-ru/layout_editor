import 'package:flutter/material.dart';
import 'component_text.dart';
import 'form_checkbox.dart';
import 'form_hidden_field.dart';
import 'form_image.dart';
import 'form_slider_button.dart';
import 'form_text_field.dart';
import 'menu.dart';
import 'component_table.dart';
import 'item.dart';
import 'page.dart';

import 'component_group.dart';
import 'form_radio.dart';

class ComponentPageMenu extends ComponentAndSourceMenu {
  ComponentPageMenu(super.layoutModel, super.target, {super.onChanged});

  @override
  List<PopupMenuEntry<Item>> getComponentMenu(void Function(Item)? onChanged) {
    var pageCount = layoutModel.root.items
        .where((element) => element.runtimeType == ComponentPage)
        .length;

    return [

      PopupMenuItem(
        child: const Text("Добавить группу"),
        onTap: () {
          var item = ComponentGroup("группа");
         // var page = layoutModel.getPageByItem(target);
          //item.properties['size']?.value = Size(page?.properties['size']?.width, 30);
          layoutModel.addItem(target, item);
          onChanged!(item);
        },
      ),

      PopupMenuItem(
        child: const Text("Добавить слайдер"),
        onTap: () {
          var item = FormSliderButton("слайдер");
          layoutModel.addItem(target, item);
          onChanged!(item);
        },
      ),
      PopupMenuItem(
        child: const Text("Добавить текст"),
        onTap: () {
          var item = ComponentText("текст");
          layoutModel.addItem(target, item);
          onChanged!(item);
        },
      ),
      PopupMenuItem(
        child: const Text("Добавить таблицу"),
        onTap: () {
          var item = ComponentTable("таблица");
          layoutModel.addItem(target, item);
          onChanged!(item);
        },
      ),
      PopupMenuItem(
        child: const Text("Добавить текстовое поле"),
        onTap: () {
          var item = FormTextField("текстовое поле");
          layoutModel.addItem(target, item);
          onChanged!(item);
        },
      ),
      PopupMenuItem(
        child: const Text("Добавить радиокнопку"),
        onTap: () {
          var item = FormRadio("радиокнопка");
          layoutModel.addItem(target, item);
          onChanged!(item);
        },
      ),
      PopupMenuItem(
        child: const Text("Добавить флажок"),
        onTap: () {
          var item = FormCheckbox("флажок");
          layoutModel.addItem(target, item);
          onChanged!(item);
        },
      ),
      PopupMenuItem(
        child: const Text("Добавить скрытое поле"),
        onTap: () {
          var item = FormHiddenField("скрытое поле");
          layoutModel.addItem(target, item);
          onChanged!(item);
        },
      ),
      PopupMenuItem(
        child: const Text("Добавить картинку"),
        onTap: () {
          var item = FormImage("картинка");
          layoutModel.addItem(target, item);
          onChanged!(item);
        },
      ),
      PopupMenuItem(
        onTap: pageCount > 1
            ? () {
          layoutModel.root.items.remove(layoutModel.curItem);
          layoutModel.curItem = layoutModel.root;

          //onChanged!(layoutModel.curItem);
        }
            : null,
        child: const Text("Удалить страницу"),
      )
    ];
  }
}