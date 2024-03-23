import 'package:flutter/material.dart';
import 'package:layout_editor/component.dart';
import 'package:layout_editor/item.dart';
import 'package:layout_editor/layout_model.dart';
import 'package:layout_editor/page.dart';
import 'package:layout_editor/source.dart';
import 'package:layout_editor/source_widget.dart';
import 'package:layout_editor/style.dart';
import 'package:layout_editor/style_widget.dart';
import 'package:provider/provider.dart';

import 'component_widget.dart';

class ComponentsAndSources extends StatefulWidget {
  final ComponentAndSourcePage _curPage;

  const ComponentsAndSources(this._curPage, {super.key});

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
      constraints: BoxConstraints(minWidth: 362, maxWidth: 362, minHeight: 720),
      child: Consumer<LayoutModel>(
        builder: (context, value, child) {
          if (widget._curPage is ComponentPage) {
            return Stack(
              //   Column(
              children: List.generate(
                widget._curPage.items.length, //widget._items.length,
                (index) => Positioned(
                  left: widget._curPage.items[index]["position"].dx,
                  top: widget._curPage.items[index]["position"].dy,
                  width: widget._curPage.items[index]["size"].width,
                  height: widget._curPage.items[index]["size"].height,
                  child: ComponentWidget.create(
                      widget._curPage.items[index] as LayoutComponent),
                ), //widget._items[index] as LayoutComponent),

                //Text(widget._items[index].type),
              ),
            );
          }

          else if (widget._curPage is SourcePage) {
            return Column(
              children: List.generate(
                widget._curPage.items.length, //widget._items.length,
                    (index) => SourceWidget.create(
                    widget._curPage.items[index] as LayoutSource),
                //widget._items[index] as LayoutComponent),

                //Text(widget._items[index].type),
              ),
            );
          }


          else {
            return Column(
              children: List.generate(
                widget._curPage.items.length, //widget._items.length,
                (index) => StyleWidget.create(
                    widget._curPage.items[index] as LayoutStyle),
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
