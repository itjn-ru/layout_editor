import 'package:flutter/material.dart';
import '../flutter_context_menu/flutter_context_menu.dart';
import 'component_text.dart';
import 'controller/events.dart';
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
  ComponentPageMenu(super.controller, super.target, {super.onChanged});

  @override
  List<PopupMenuEntry<Item>> getComponentMenu(void Function(Item)? onChanged) {
    var pageCount = controller.layoutModel.root.items
        .where((element) => element.runtimeType == ComponentPage)
        .length;

    return [
      PopupMenuItem(
        child: const Text("Добавить группу"),
        onTap: () {
          var item = ComponentGroup("группа");
          // var page = controller.layoutModel.getPageByItem(target);
          //item.properties['size']?.value = Size(page?.properties['size']?.width, 30);
          controller.layoutModel.addItem(target, item);
          onChanged!(item);
        },
      ),
      PopupMenuItem(
        child: const Text("Добавить слайдер"),
        onTap: () {
          var item = FormSliderButton("слайдер");
          controller.layoutModel.addItem(target, item);
          onChanged!(item);
        },
      ),
      PopupMenuItem(
        child: const Text("Добавить текст"),
        onTap: () {
          var item = ComponentText("текст");
          controller.layoutModel.addItem(target, item);
          onChanged!(item);
        },
      ),
      PopupMenuItem(
        child: const Text("Добавить таблицу"),
        onTap: () {
          var item = ComponentTable("таблица");
          controller.layoutModel.addItem(target, item);
          onChanged!(item);
        },
      ),
      PopupMenuItem(
        child: const Text("Добавить текстовое поле"),
        onTap: () {
          var item = FormTextField("текстовое поле");
          controller.layoutModel.addItem(target, item);
          onChanged!(item);
        },
      ),
      PopupMenuItem(
        child: const Text("Добавить радиокнопку"),
        onTap: () {
          var item = FormRadio("радиокнопка");
          controller.layoutModel.addItem(target, item);
          onChanged!(item);
        },
      ),
      PopupMenuItem(
        child: const Text("Добавить флажок"),
        onTap: () {
          var item = FormCheckbox("флажок");
          controller.layoutModel.addItem(target, item);
          onChanged!(item);
        },
      ),
      PopupMenuItem(
        child: const Text("Добавить скрытое поле"),
        onTap: () {
          var item = FormHiddenField("скрытое поле");
          controller.layoutModel.addItem(target, item);
          onChanged!(item);
        },
      ),
      PopupMenuItem(
        child: const Text("Добавить картинку"),
        onTap: () {
          var item = FormImage("картинка");
          controller.layoutModel.addItem(target, item);
          onChanged!(item);
        },
      ),
      PopupMenuItem(
        onTap: pageCount > 1
            ? () {
                controller.layoutModel.root.items.remove(controller.layoutModel.curItem);
                controller.layoutModel.curItem = controller.layoutModel.root;

                //onChanged!(controller.layoutModel.curItem);
              }
            : null,
        child: const Text("Удалить страницу"),
      )
    ];
  }

  @override
  List<ContextMenuEntry> getContextMenu(
      void Function(LayoutModelEvent event)? onChanged) {
    var pageCount = controller.layoutModel.root.items
        .where((element) => element.runtimeType == ComponentPage)
        .length;
    return [
      const MenuHeader(text: "Редактирование"),
      MenuItem.submenu(
        label: 'Добавить',
        icon: Icons.add,
        items: [
          MenuItem(
            label: 'Добавить группу',
            icon: Icons.widgets,
            onSelected: () {
              var item = ComponentGroup("группа");
              controller.layoutModel.addItem(target, item);
              onChanged!(AddItemEvent(id: item.id));
            },
          ),
          MenuItem(
            label: 'Добавить слайдер',
            icon: Icons.smart_button,
            onSelected: () {
              var item = FormSliderButton("слайдер");
              controller.layoutModel.addItem(target, item);
              onChanged!(AddItemEvent(id: item.id));
            },
          ),
          MenuItem(
            label: 'Добавить текст',
            icon: Icons.text_snippet,
            onSelected: () {
              var item = ComponentText("текст");
              controller.layoutModel.addItem(target, item);
              onChanged!(AddItemEvent(id: item.id));
            },
          ),
          MenuItem(
            label: 'Добавить таблицу',
            icon: Icons.table_chart,
            onSelected: () {
              var item = ComponentTable("таблица");
              controller.layoutModel.addItem(target, item);
              onChanged!(AddItemEvent(id: item.id));
            },
          ),
          MenuItem(
            label: 'Добавить текстовое поле',
            icon: Icons.text_snippet,
            onSelected: () {
              var item = FormTextField("текстовое поле");
              controller.layoutModel.addItem(target, item);
              onChanged!(AddItemEvent(id: item.id));
            },
          ),
          MenuItem(
            label: 'Добавить радиокнопку',
            icon: Icons.radio_button_checked,
            onSelected: () {
              var item = FormRadio("радиокнопка");
              controller.layoutModel.addItem(target, item);
              onChanged!(AddItemEvent(id: item.id));
            },
          ),
          MenuItem(
            label: 'Добавить флажок',
            icon: Icons.check_box,
            onSelected: () {
              var item = FormCheckbox("флажок");
              controller.layoutModel.addItem(target, item);
              onChanged!(AddItemEvent(id: item.id));
            },
          ),
          MenuItem(
            label: 'Добавить скрытое поле',
            icon: Icons.text_fields,
            onSelected: () {
              var item = FormHiddenField("скрытое поле");
              controller.layoutModel.addItem(target, item);
              onChanged!(AddItemEvent(id: item.id));
            },
          ),
          MenuItem(
            label: 'Добавить картинку',
            icon: Icons.picture_in_picture,
            onSelected: () {
              var item = FormImage("картинка");
              controller.layoutModel.addItem(target, item);
              onChanged!(AddItemEvent(id: item.id));
            },
          ),
        ],
      ),
      const MenuDivider(),
      MenuItem(
        label: 'Копировать',
        icon: Icons.delete,
        onSelected: () {
          controller.clipboard.copySelection();
        },
      ),
      MenuItem(
        label: 'Вставить',
        icon: Icons.delete,
        onSelected: () {
          controller.clipboard.pasteSelection(parent: target);
        },
      ),
      MenuItem(
        label: 'Вырезать',
        icon: Icons.content_cut,
        onSelected: () {
          controller.clipboard.cutSelection();
        },
      ),
      const MenuDivider(),
      MenuItem(
        label: 'Удалить',
        icon: Icons.delete,
        onSelected: () {
          controller.layoutModel.deleteItem(target);
          onChanged!(RemoveItemEvent(id: target.id));
        },
      ),
    ];
  }
}
