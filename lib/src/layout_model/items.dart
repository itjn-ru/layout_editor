import 'component_table.dart';
import 'package:flutter/material.dart';
import 'item.dart';
import 'layout_model.dart';
import 'page.dart';
import 'root.dart';

import 'menu.dart';

class Items extends StatefulWidget {
  final Item _item;
final LayoutModel layoutModel;
  final void Function(Item item)? onItemChanged;

  const Items(this._item, this.layoutModel, {this.onItemChanged, super.key});

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
        ItemWidget(item, widget.layoutModel),
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
      child = ItemWidget(item,widget.layoutModel);
    }

    final curPageType = switch (widget._item.runtimeType) {
      const (SourcePage) => SourcePage,
      const (StylePage) => StylePage,
      _ => ComponentPage
    };

    final curItem = widget.layoutModel.curItemOnPage[curPageType];

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
          widget.layoutModel.curComponentItem = item;
        }
        widget.layoutModel.curItem = item;
        setState(() {
          widget.layoutModel.curItem = item;

          if (widget.onItemChanged != null) {
            widget.onItemChanged!(item);
          }
        });
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ItemWidget extends StatefulWidget {
  final Item _item;
final LayoutModel layoutModel;
  const ItemWidget(this._item, this.layoutModel, {super.key});

  @override
  State<StatefulWidget> createState() => ItemWidgetState();
}

class ItemWidgetState extends State<ItemWidget> {
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
        padding: const EdgeInsets.only(bottom: 5, top: 5, left: 5, right: 5),
        decoration: BoxDecoration(
          color: dragging ? Colors.green : Colors.transparent,
        ),
        child: DragTarget<String>(onMove: (DragTargetDetails<String> details) {
          setState(() {
            dragging = true;
          });
        }, onLeave: (details) {
          setState(() {
            dragging = false;
          });
        }, onAcceptWithDetails: (DragTargetDetails<String> details) {
          setState(() {
            dragging = false;
            widget._item.properties['source']?.value = details.data;
            final source = details.data ?? '';
            if (source != '') {
                final SourcePage page =
                    widget.layoutModel.root.items.whereType<SourcePage>().first;
                final Item sourceData =
                page.items.firstWhere((e) => e.properties['name']?.value == source);
                widget._item.items.clear();
                var row = ComponentTableRow("строка");

                for(final sourceItem in sourceData.items){
                  row.items.add(ComponentTableCell("ячейка",sourceItem['name']));
                  widget._item.items.add(ComponentTableColumn(sourceItem['name']));
                }
                var rowGroup = ComponentTableRowGroup("группа строк");
                rowGroup.items.add(row);
                widget._item.items.add(rowGroup);
                setState(() {
                });
            }
          });
        }, builder: (
          BuildContext context,
          List<dynamic> accepted,
          List<dynamic> rejected,
        ) {
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget._item['name'],
                  overflow: TextOverflow.clip,
                  maxLines: 2,
                ),
                if (hover)
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
          );
        }),
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
