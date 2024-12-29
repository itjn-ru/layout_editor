import 'package:flutter/material.dart';
import 'menu.dart';
import 'item.dart';

class FormHiddenFieldMenu extends ComponentAndSourceMenu {
  FormHiddenFieldMenu(super.layoutModel, super.target, {super.onChanged});

  @override
  List<PopupMenuEntry<Item>> getComponentMenu(void Function(Item)? onChanged) {
    return [
      PopupMenuItem(
        child: const Text("Удалить скрытое поле"),
        onTap: () {
          layoutModel.deleteItem(target);
          onChanged!(target);
        },
      )
    ];
  }
}
