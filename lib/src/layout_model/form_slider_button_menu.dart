import 'package:flutter/material.dart';
import 'item.dart';
import 'menu.dart';

class FormSliderButtonMenu extends ComponentAndSourceMenu {
  FormSliderButtonMenu(super.layoutModel, super.target, {super.onChanged});

  @override
  List<PopupMenuEntry<Item>> getComponentMenu(void Function(Item)? onChanged) {
    return [
      PopupMenuItem(
        child: Text("Удалить переключатель"),
        onTap: () {
          layoutModel.deleteItem(target);
          onChanged!(target);
        },
      )
    ];
  }
}