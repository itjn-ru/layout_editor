import 'package:flutter/material.dart';
import 'package:layout_editor/component.dart';
import 'package:layout_editor/item.dart';
import 'package:layout_editor/layout_model.dart';
import 'package:layout_editor/page.dart';
import 'package:layout_editor/source.dart';
import 'package:layout_editor/source_widget.dart';
import 'package:provider/provider.dart';

import 'component_widget.dart';

class ComponentsAndSources extends StatefulWidget {
  final List<Item> _items;

  const ComponentsAndSources(this._items, {super.key});

  @override
  State<StatefulWidget> createState() {
    return ComponentsAndSourcesState();
  }
}

class ComponentsAndSourcesState extends State<ComponentsAndSources> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 362,
      height: 720,
      decoration: BoxDecoration(border: Border.all(width: 1)),
      child: Consumer<LayoutModel>(
        builder: (context, value, child) {
          if (value.curPage is ComponentPage) {
            return Stack(
              //   Column(
              children: List.generate(
                value.curPage.items.length, //widget._items.length,
                (index) => Positioned(
                  left: value.curPage.items[index]["position"].dx,
                  top: value.curPage.items[index]["position"].dy,
                  width: value.curPage.items[index]["size"].width,
                  height: value.curPage.items[index]["size"].height,
                  child: ComponentWidget.create(
                      value.curPage.items[index] as LayoutComponent),
                ), //widget._items[index] as LayoutComponent),

                //Text(widget._items[index].type),
              ),
            );
          } else {
            return Column(
              children: List.generate(
                value.curPage.items.length, //widget._items.length,
                (index) => SourceWidget.create(
                    value.curPage.items[index] as LayoutSource),
                //widget._items[index] as LayoutComponent),

                //Text(widget._items[index].type),
              ),
            );
          }
        },
      ),
    );
  }
}
