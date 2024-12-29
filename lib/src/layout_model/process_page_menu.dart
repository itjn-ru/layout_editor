import 'package:flutter/material.dart';
import 'menu.dart';
import 'item.dart';
import 'process_element.dart';

class ProcessPageMenu extends ComponentAndSourceMenu {
  ProcessPageMenu(super.layoutModel, super.target, {super.onChanged});

  @override
  List<PopupMenuEntry<Item>> getComponentMenu(void Function(Item)? onChanged) {
    return [
      PopupMenuItem(
        child: const Text("Добавить процесс"),
        onTap: () {
          var item = ProcessElement("процесс");
          layoutModel.addItem(target, item);
          onChanged!(item);
        },
      )
    ];
  }
}
