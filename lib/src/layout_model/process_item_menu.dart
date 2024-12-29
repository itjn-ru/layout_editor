import 'package:flutter/material.dart';
import 'component_text.dart';
import 'form_checkbox.dart';
import 'form_text_field.dart';
import 'form_text_field.dart';
import 'menu.dart';
import 'component_table.dart';
import 'item.dart';
import 'page.dart';

import 'form_hidden_field.dart';
import 'form_radio.dart';
import 'form_slider_button.dart';
import 'process_element.dart';

class ProcessItemMenu extends ComponentAndSourceMenu {
  ProcessItemMenu(super.layoutModel, super.target, {super.onChanged});

  @override
  List<PopupMenuEntry<Item>> getComponentMenu(void Function(Item)? onChanged) {

    return [
      PopupMenuItem(
        child: const Text("Добавить событие"),
        onTap: () {
          var item = ProcessElement("Событие");
          layoutModel.addItem(target, item);
          onChanged!(item);
        },
      ),
      PopupMenuItem(
        child: const Text("Удалить процесс"),
        onTap: () {
          layoutModel.deleteItem(layoutModel.curItem);
          onChanged!(layoutModel.curItem);
        },
      ),
    ];
  }
}