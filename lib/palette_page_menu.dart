import 'package:flutter/material.dart';
import 'package:layout_editor/menu.dart';
import 'package:layout_editor/component_table.dart';
import 'package:layout_editor/item.dart';
import 'package:layout_editor/page.dart';
import 'package:layout_editor/root.dart';
import 'package:layout_editor/palette_color.dart';
import 'package:layout_editor/source_table.dart';
import 'package:layout_editor/source_variable.dart';

class PalettePageMenu extends ComponentAndSourceMenu {
  PalettePageMenu(super.layoutModel, super.target, {super.onChanged});

  @override
  List<PopupMenuEntry<Item>> getComponentMenu(void Function(Item)? onChanged) {
    var pageCount = layoutModel.root.items
        .where((element) => element.runtimeType == SourcePage)
        .length;

    return [

      PopupMenuItem(
        child: Text("Добавить цвет"),
        onTap: () {

          var item = StyleElement("цвет");
          layoutModel.addItem(target, item);
          onChanged!(item);

        },
      )

    ];
  }
}
