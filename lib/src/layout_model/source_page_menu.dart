import 'package:flutter/material.dart';
import 'item.dart';
import 'menu.dart';
import 'source_table.dart';
import 'source_variable.dart';

class SourcePageMenu extends ComponentAndSourceMenu {
  SourcePageMenu(super.layoutModel, super.target, {super.onChanged});

  @override
  List<PopupMenuEntry<Item>> getComponentMenu(void Function(Item)? onChanged) {

    return [

      PopupMenuItem(
        child: const Text('Добавить переменную'),
        onTap: () {

          final item = SourceVariable('переменная');
          layoutModel.addItem(target, item);
          onChanged!(item);

        },
      ),

      PopupMenuItem(
        child: const Text('Добавить таблицу'),
        onTap: () {

          final item = SourceTable('таблица');
          layoutModel.addItem(target, item);
          onChanged!(item);

        },
      )

    ];
  }
}
