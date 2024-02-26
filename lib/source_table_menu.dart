import 'package:flutter/material.dart';
import 'package:layout_editor/menu.dart';
import 'package:layout_editor/item.dart';
import 'package:layout_editor/source.dart';
import 'package:layout_editor/source_table.dart';

class SourceTableMenu extends ComponentAndSourceMenu {
  SourceTableMenu(super.layoutModel, super.target, {super.onChanged, super.onDeleted});

  @override
  List<PopupMenuEntry<Item>> getComponentMenu(void Function(Item?)? onChanged) {
    if (layoutModel.curItem is LayoutSource) {
      return [
        PopupMenuItem(
          child: Text("Добавить колонку"),
          onTap: () {
            var item = SourceTableColumn("колонка");
            layoutModel.addItem(target, item);
            onChanged!(item);
          },
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
        case SourceTableColumn:
          return [
            PopupMenuItem(
              child: Text("Удалить колонку"),
              onTap: layoutModel.curComponent!.items
                          .whereType<SourceTableColumn>()
                          .length >
                      1
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
