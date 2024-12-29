import 'component_table.dart';
import 'package:flutter/material.dart';
import 'item.dart';
import 'layout_model.dart';
import 'page.dart';
import 'root.dart';

import 'menu.dart';

class ProcessItems extends StatefulWidget {
  final Item _item;
  final LayoutModel layoutModel;
  final void Function(Item item)? onItemChanged;

  const ProcessItems(this._item, this.layoutModel,
      {this.onItemChanged, super.key});

  @override
  State<StatefulWidget> createState() {
    return ProcessItemsState();
  }
}

class ProcessItemsState extends State<ProcessItems>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
          width: constraints.maxWidth,
          child: _buildItem(widget._item, true, constraints.maxWidth));
    });
  }

  Widget _buildItem(Item item, bool first, double width) {
    Widget child;
    final curItem = widget.layoutModel.curItem;
    if (item.items.isNotEmpty) {
      final children = <Widget>[];

      final items = item.items;

      children.addAll(List.generate(
        items.length,
        (index) => SizedBox(
            //width: (width - 5) / (first ? 1 : items.length),
            child: Padding(
                padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                child: _buildItem(items[index], false,
                    (width) / (first ? 1 : items.length) - 5 * items.length))),
      ));

      child = Column(
        children: [
          ProcessItemWidget(item, widget.layoutModel),
         /* Wrap(
              direction: first ? Axis.vertical : Axis.horizontal,
              children: children),*/
          Column(children: children),
        ],
      );
    } else {
      child = InkWell(
        onTap: () {
          if (item == curItem) {
            return;
          }
          widget.layoutModel.curItem = item;
          setState(() {
            widget.layoutModel.curItem = item;

            if (widget.onItemChanged != null) {
              widget.onItemChanged!(item);
            }
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: item == curItem
                ? Colors.amber
                : item is ComponentAndSourcePage
                    ? Colors.grey
                    : Colors.white,
            border: Border.all(),
          ),
          child: ProcessItemWidget(item, widget.layoutModel),
        ),
      );
    }

    return InkWell(
        onTap: () {
          if (item == curItem) {
            return;
          }
          widget.layoutModel.curItem = item;
          setState(() {
            widget.layoutModel.curItem = item;

            if (widget.onItemChanged != null) {
              widget.onItemChanged!(item);
            }
          });
        },
        child: Container(
            decoration: BoxDecoration(
              color: item == curItem
                  ? Colors.amber
                  : item is ComponentAndSourcePage
                      ? Colors.grey
                      : Colors.white,
              border: Border.all(),
            ),
            child: child));
  }

  @override
  bool get wantKeepAlive => true;
}



class ProcessItemWidget extends StatefulWidget {
  final Item _item;
  final LayoutModel layoutModel;

  const ProcessItemWidget(this._item, this.layoutModel, {super.key});

  @override
  State<StatefulWidget> createState() => ProcessItemWidgetState();
}

class ProcessItemWidgetState extends State<ProcessItemWidget> {
  late bool hover;
  bool dragging = false;

  @override
  void initState() {
    super.initState();
    hover = true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: dragging ? Colors.green : Colors.transparent,
      ),
      child: MouseRegion(
        onEnter: (event) {
          setState(() {
            hover = true;
          });
        },
        onExit: (event) {
          setState(() {
            hover = false;
          });
        },
        child: Row(
         // alignment: WrapAlignment.spaceBetween,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget._item['name'],
                overflow: TextOverflow.clip,
                maxLines: 2,
              ),
            ),
            InkWell(
              child: const Padding(
                padding: EdgeInsets.only(left: 5, right: 15),
                child: Icon(
                  Icons.more_vert,
                  size: 18,
                ),
              ),
              onTapDown: (details) {
                final menu = ComponentAndSourceMenu.create(
                    widget.layoutModel, widget._item);

                final menuItems = menu.getComponentMenu(
                  (p0) {},
                );

                if (menuItems.isEmpty) {
                  return;
                }

                final offset = details.globalPosition;

                showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(
                      offset.dx,
                      offset.dy,
                      MediaQuery.of(context).size.width - offset.dx,
                      MediaQuery.of(context).size.height - offset.dy,
                    ),
                    items: menuItems);
              },
            ),
          ],
        ),
      ),
    );

    return MouseRegion(
      onEnter: (event) {
        setState(() {
          hover = true;
        });
      },
      onExit: (event) {
        setState(() {
          hover = false;
        });
      },
    );
  }
}
