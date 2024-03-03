import 'package:flutter/material.dart';
import 'package:layout_editor/menu.dart';
import 'package:layout_editor/component_table.dart';
import 'package:layout_editor/item.dart';
import 'package:layout_editor/page.dart';
import 'package:layout_editor/root.dart';
import 'package:layout_editor/source_table.dart';
import 'package:layout_editor/source_variable.dart';

class SourcePageMenu extends ComponentAndSourceMenu {
  SourcePageMenu(super.layoutModel, super.target, {super.onChanged});

  @override
  List<PopupMenuEntry<Item>> getComponentMenu(void Function(Item)? onChanged) {
    var pageCount = layoutModel.root.items
        .where((element) => element.runtimeType == SourcePage)
        .length;

    return [

      PopupMenuItem(
        child: Text("Добавить переменную"),
        onTap: () {

          var item = SourceVariable("переменная");
          layoutModel.addItem(target, item);
          onChanged!(item);

        },
      ),

      PopupMenuItem(
        child: Text("Добавить таблицу"),
        onTap: () {

          var item = SourceTable("таблица");
          layoutModel.addItem(target, item);
          onChanged!(item);

        },
      )

    ];
  }
}
