import 'package:flutter/material.dart';
import 'menu.dart';
import 'item.dart';
import 'style_element.dart';

class StylePageMenu extends ComponentAndSourceMenu {
  StylePageMenu(super.layoutModel, super.target, {super.onChanged});

  @override
  List<PopupMenuEntry<Item>> getComponentMenu(void Function(Item)? onChanged) {
    return [
      PopupMenuItem(
        child: const Text("Добавить стиль"),
        onTap: () {

          var item = StyleElement("стиль");
          layoutModel.addItem(target, item);
          onChanged!(item);

        },
      )

    ];
  }
}
