import 'package:flutter/material.dart';
import 'package:layout_editor/menu.dart';
import 'package:layout_editor/component_table.dart';
import 'package:layout_editor/item.dart';
import 'package:layout_editor/page.dart';
import 'package:layout_editor/root.dart';

class ComponentRootMenu extends ComponentAndSourceMenu {
  ComponentRootMenu(super.layoutModel, super.target, {super.onChanged});

  @override
  List<PopupMenuEntry<Item>> getComponentMenu(void Function(Item)? onChanged) {
    return [
      PopupMenuItem(
        child: Text("Добавить страницу"),
        onTap: () {
          var item = ComponentPage("страница");
          layoutModel.addItem(target, item);
          onChanged!(item);
        },
      )
    ];
  }
}
