import 'canvas/context_menu.dart';
import 'package:flutter/material.dart';
import 'controller/events.dart';
import 'controller/layout_model_controller.dart';
import 'item.dart';
import 'page.dart';
import 'root.dart';

import 'menu.dart';

class Items extends StatefulWidget {
  final Item _item;
  final LayoutModelController controller;
//final LayoutModel layoutModel;

  const Items(this._item, this.controller, {super.key});

  @override
  State<StatefulWidget> createState() {
    return ItemsState();
  }
}

class ItemsState extends State<Items> with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _buildItem(widget._item);
  } 

  Widget _buildItem(Item item) {
    Widget child;

    if (item.items.isNotEmpty) {
      final children = <Widget>[];
      children.add(
        ItemWidget(item, widget.controller),
      );

      final items = item is Root
          ? item.items.whereType<ComponentPage>().toList()
          : item.items;

      children
        ..addAll(List.generate(
          items.length,
          (index) => Padding(
              padding: index == items.length - 1
                  ? const EdgeInsets.only(left: 5, right: 5)
                  : const EdgeInsets.only(left: 5, right: 5, bottom: 5),
              child: _buildItem(items[index])),
        ))
        ..add(Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                item['name'],
                softWrap: true,
              )),
            ],
          ),
        ));

      child = ListView(shrinkWrap: true, children: children);
    } else {
      child = ItemWidget(item,widget.controller);
    }

    final curPageType = switch (widget._item.runtimeType) {
      const (SourcePage) => SourcePage,
      const (StylePage) => StylePage,
      const (ProcessPage) => ProcessPage,
      _ => ComponentPage
    };

    final curItem = widget.controller.layoutModel.curItemOnPage[curPageType];

    return InkWell(
      child: Container(
        //padding: const EdgeInsets.only(left: 5,  right: 5),
        /*const EdgeInsets.all(5),*/
        decoration: BoxDecoration(
          color: item == curItem
              ? Colors.amber
              : item is ComponentAndSourcePage
                  ? Colors.grey
                  : Colors.white,
          border: Border.all(),
        ),
        child: child,
      ),
      onTap: () {
        if (item == curItem) {
          return;
        }
        if (curPageType is ComponentPage) {
          widget.controller.layoutModel.curComponentItem = item;
        }
        widget.controller.layoutModel.curItem = item;
        setState(() {
          widget.controller.layoutModel.curItem = item;
        });
        widget.controller.eventBus.emit(SelectionEvent(id: item.id));
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ItemWidget extends StatefulWidget {
  final Item item;
final LayoutModelController controller;
  const ItemWidget(this.item, this.controller, {super.key});

  @override
  State<StatefulWidget> createState() => ItemWidgetState();
}

class ItemWidgetState extends State<ItemWidget> {
  late bool hover;
  bool dragging = false;
  Offset? position;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      return MouseRegion(
        onEnter: (event) {
          setState(() {
            position = event.position;
          });
        },
        child: GestureDetector(
          onTap: () {
            if (widget.item == widget.controller.layoutModel.curItem) {
              return;
            }
            widget.controller.layoutModel.curItem = widget.item;
            widget.controller.eventBus.emit(SelectionEvent(id: widget.item.id));
          },
          onSecondaryTap: () {
            final menu = ComponentAndSourceMenu.create(
                widget.controller, widget.item);

            final menuItems = menu.getContextMenu(
                  (event) => widget.controller.eventBus.emit(event),
            );
            createAndShowContextMenu(
              context,
              entries: menuItems,
              position: position!,
            );
            if (widget.item == widget.controller.layoutModel.curItem) {
              return;
            }
            widget.controller.layoutModel.curItem = widget.item;
            widget.controller.eventBus.emit(SelectionEvent(id: widget.item.id));
          },
          child: Container(
            padding: const EdgeInsets.only(bottom: 5, top: 5, left: 5, right: 5),
            decoration: BoxDecoration(
              color: dragging ? Colors.green : Colors.transparent,
            ),
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.item['name'],
                  overflow: TextOverflow.clip,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
      );

  }
}
