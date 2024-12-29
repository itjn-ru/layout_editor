import 'package:flutter/material.dart';
import 'form_hidden_field.dart';
import 'menu.dart';
import 'item.dart';
import 'page.dart';

import 'component_group.dart';

class ComponentRootMenu extends ComponentAndSourceMenu {
  ComponentRootMenu(super.layoutModel, super.target, {super.onChanged});

  @override
  List<PopupMenuEntry<Item>> getComponentMenu(void Function(Item)? onChanged) {
    return [
      PopupMenuItem(
        child: const Text("Добавить страницу"),
        onTap: () {
          final ComponentPage item = ComponentPage("страница");
          layoutModel.addItem(target, item);
          onChanged!(item);
        },
      ),
    ];
  }
}
