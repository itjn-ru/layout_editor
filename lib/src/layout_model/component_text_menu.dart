import 'package:flutter/material.dart';
import 'menu.dart';
import 'item.dart';

class ComponentTextMenu extends ComponentAndSourceMenu {
  ComponentTextMenu(super.layoutModel, super.target, {super.onChanged});

  @override
  List<PopupMenuEntry<Item>> getComponentMenu(void Function(Item)? onChanged) {
    return [
      PopupMenuItem(
        child: const Text('Удалить текст'),
        onTap: () {
          layoutModel.deleteItem(target);
          onChanged!(target);
        },
      )
    ];
  }
}
