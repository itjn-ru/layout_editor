import 'package:flutter/material.dart';
import 'menu.dart';
import 'item.dart';

class FormRadioMenu extends ComponentAndSourceMenu {
  FormRadioMenu(super.layoutModel, super.target, {super.onChanged});

  @override
  List<PopupMenuEntry<Item>> getComponentMenu(void Function(Item)? onChanged) {
    return [
      PopupMenuItem(
        child: const Text("Удалить радиокнопку"),
        onTap: () {
          layoutModel.deleteItem(target);
          onChanged!(target);
        },
      )
    ];
  }
}