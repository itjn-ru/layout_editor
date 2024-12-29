import 'package:flutter/material.dart';
import 'menu.dart';
import 'component_table.dart';
import 'item.dart';
import 'page.dart';
import 'root.dart';

class StyleElementMenu extends ComponentAndSourceMenu {
  StyleElementMenu(super.layoutModel, super.target, {super.onChanged});

  @override
  List<PopupMenuEntry<Item>> getComponentMenu(void Function(Item)? onChanged) {
    return [
      PopupMenuItem(
        child: Text("Удалить стиль"),
        onTap: () {
          layoutModel.deleteItem(target);
          onChanged!(target);
        },
      )
    ];
  }
}
