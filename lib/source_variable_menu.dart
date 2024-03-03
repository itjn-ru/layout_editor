import 'package:flutter/material.dart';
import 'package:layout_editor/menu.dart';
import 'package:layout_editor/component_table.dart';
import 'package:layout_editor/item.dart';
import 'package:layout_editor/page.dart';
import 'package:layout_editor/root.dart';

class SourceVariableMenu extends ComponentAndSourceMenu {
  SourceVariableMenu(super.layoutModel, super.target, {super.onChanged});

  @override
  List<PopupMenuEntry<Item>> getComponentMenu(void Function(Item)? onChanged) {
    return [
      PopupMenuItem(
        child: Text("Удалить переменную"),
        onTap: () {
          layoutModel.deleteItem(target);
          onChanged!(target);
        },
      )
    ];
  }
}
