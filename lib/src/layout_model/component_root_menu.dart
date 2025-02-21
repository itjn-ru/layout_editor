import 'package:flutter/material.dart';
import '../flutter_context_menu/flutter_context_menu.dart';
import 'controller/events.dart';
import 'menu.dart';
import 'item.dart';
import 'page.dart';


class ComponentRootMenu extends ComponentAndSourceMenu {
  ComponentRootMenu(super.controller, super.target, {super.onChanged});

  @override
  List<PopupMenuEntry<Item>> getComponentMenu(void Function(Item)? onChanged) {
    return [
      PopupMenuItem(
        child: const Text("Добавить страницу"),
        onTap: () {
          final ComponentPage item = ComponentPage("страница");
          controller.layoutModel.addItem(target, item);
          onChanged!(item);
        },
      ),
    ];
  }

  @override
  List<ContextMenuEntry> getContextMenu(
      void Function(LayoutModelEvent event)? onChanged) {
    return [
      const MenuHeader(text: "Редактирование"),
      MenuItem(
        label: 'Добавить страницу',
        icon: Icons.add,
        onSelected: () {
          final ComponentPage item = ComponentPage("страница");
          controller.layoutModel.addItem(target, item);
          onChanged!(AddItemEvent(id: item.id));
        },
      ),
    ];
  }
}
