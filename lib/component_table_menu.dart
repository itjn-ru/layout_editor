import 'package:flutter/material.dart';
import 'package:layout_editor/component.dart';
import 'package:layout_editor/menu.dart';
import 'package:layout_editor/component_table.dart';
import 'package:layout_editor/item.dart';
import 'package:layout_editor/page.dart';
import 'package:layout_editor/root.dart';

class ComponentTableMenu extends ComponentAndSourceMenu {
  ComponentTableMenu(super.layoutModel, super.target, {super.onChanged, super.onDeleted});

  @override
  List<PopupMenuEntry<Item>> getComponentMenu(void Function(Item?)? onChanged) {
    if (layoutModel.curItem is LayoutComponent) {
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
            layoutModel.deleteItem(layoutModel.curItem);

//            layoutModel.curPage.items.remove(layoutModel.curItem);
//            layoutModel.curItem = layoutModel.curPage;

            onChanged!(layoutModel.curItem);
          },
        ),
      ];
    } else {
      switch (layoutModel.curItem.runtimeType) {
        case ComponentTableColumn:
          return [
            PopupMenuItem(
              child: Text("Удалить колонку"),
              onTap: layoutModel.curComponent!.items
                          .whereType<ComponentTableColumn>()
                          .length >
                      1
                  ? () {
                      layoutModel.deleteItem(layoutModel.curItem);
                      onChanged!(layoutModel.curItem);
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
              onTap: layoutModel.curComponent!.items
                          .whereType<ComponentTableRowGroup>()
                          .length >
                      1
                  ? () {
                      layoutModel.deleteItem(layoutModel.curItem);
                      onChanged!(layoutModel.curItem);
                    }
                  : null,
            ),
          ];

        case ComponentTableRow:

          //Ищем группу строк, владеющую этой строкой
          ComponentTableRowGroup? foundGroup;
          layoutModel.curComponent!.items
              .whereType<ComponentTableRowGroup>()
              .forEach((rowGroup) {
            if (rowGroup.items
                .where((row) => row == layoutModel.curItem)
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
                      layoutModel.deleteItem(layoutModel.curItem);
                      onChanged!(layoutModel.curItem);
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
