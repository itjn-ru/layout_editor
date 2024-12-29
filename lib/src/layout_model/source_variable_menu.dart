import 'package:flutter/material.dart';
import 'menu.dart';
import 'item.dart';

class SourceVariableMenu extends ComponentAndSourceMenu {
  SourceVariableMenu(super.layoutModel, super.target, {super.onChanged});

  @override
  List<PopupMenuEntry<Item>> getComponentMenu(void Function(Item)? onChanged) {
    return [
      PopupMenuItem(
        child: const Text('Удалить переменную'),
        onTap: () {
          layoutModel.deleteItem(target);
          onChanged!(target);
        },
      )
    ];
  }
}
