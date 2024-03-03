import 'package:flutter/material.dart';
import 'package:layout_editor/component.dart';
import 'package:layout_editor/menu.dart';
import 'package:layout_editor/component_table.dart';
import 'package:layout_editor/item.dart';
import 'package:layout_editor/page.dart';
import 'package:layout_editor/root.dart';

class ComponentTableMenu extends ComponentAndSourceMenu {
  ComponentTableMenu(super.layoutModel, super.target,
      {super.onChanged, super.onDeleted});

  @override
  List<PopupMenuEntry<Item>> getComponentMenu(void Function(Item?)? onChanged) {
    if (target is LayoutComponent) {
      return [
        PopupMenuItem(
          child: Text("Добавить колонку"),
          onTap: () {
            var item = ComponentTableColumn("колонка");
            layoutModel.addItem(target, item);
            onChanged!(item);
          },
        ),
        PopupMenuItem(
          child: Text("Добавить группу строк"),
          onTap: () {
            var item = ComponentTableRowGroup("группа строк");
            layoutModel.addItem(target, item);
            onChanged!(item);
          },
          //value: ComponentTable("Таблица"),
        ),
        PopupMenuItem(
          child: const Text("Удалить таблицу"),
          onTap: () {
            layoutModel.deleteItem(target);

//            layoutModel.curPage.items.remove(layoutModel.curItem);
//            layoutModel.curItem = layoutModel.curPage;

            onChanged!(target);
          },
        ),
      ];
    } else {
      switch (target.runtimeType) {
        case ComponentTableColumn:
          return [
            PopupMenuItem(
              child: Text("Удалить колонку"),
              onTap: layoutModel.getComponentByItem(target)!.items
                          .whereType<ComponentTableColumn>()
                          .length >
                      1
                  ? () {
                      layoutModel.deleteItem(target);
                      onChanged!(target);
                    }
                  : null,
            ),
          ];
        case ComponentTableRowGroup:
          return [
            PopupMenuItem(
              child: Text("Добавить строку"),
              onTap: () {
                var item = ComponentTableRow("строка");
                layoutModel.addItem(target, item);
                onChanged!(item);
              },
            ),
            PopupMenuItem(
              child: Text("Удалить группу строк"),
              onTap: layoutModel.getComponentByItem(target)!.items
                          .whereType<ComponentTableRowGroup>()
                          .length >
                      1
                  ? () {
                      layoutModel.deleteItem(target);
                      onChanged!(target);
                    }
                  : null,
            ),
          ];

        case ComponentTableRow:

          //Ищем группу строк, владеющую этой строкой
          ComponentTableRowGroup? foundGroup;
          layoutModel.getComponentByItem(target)!.items
              .whereType<ComponentTableRowGroup>()
              .forEach((rowGroup) {
            if (rowGroup.items
                .where((row) => row == target)
                .isNotEmpty) {
              foundGroup = rowGroup;
            }
          });

          if (foundGroup == null) {
            return [];
          }

          return [
            PopupMenuItem(
              child: Text("Удалить строку"),
              onTap: foundGroup!.items.whereType<ComponentTableRow>().length > 1
                  ? () {
                      layoutModel.deleteItem(target);
                      onChanged!(target);
                    }
                  : null,
            ),
          ];

        default:
          return [];
      }
    }
  }
}
