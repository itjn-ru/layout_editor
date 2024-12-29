import 'package:flutter/material.dart';
import 'menu.dart';
import 'item.dart';
import 'source.dart';
import 'source_table.dart';

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
              onTap: layoutModel.getComponentByItem(target)!.items
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
