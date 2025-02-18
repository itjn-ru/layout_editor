import 'package:flutter/gestures.dart';

import '../flutter_context_menu/components/menu_header.dart';
import '../flutter_context_menu/components/menu_item.dart';
import '../flutter_context_menu/core/models/context_menu_entry.dart';
import 'canvas/context_menu.dart';
import 'component_table.dart';
import 'package:flutter/material.dart';
import 'controller/helpers/renderbox.dart';
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
    List<ContextMenuEntry> editorContextMenuEntries=
      [
        const MenuHeader(text: "Editor Menu"),
        MenuItem(
            label: 'Center View',
            icon: Icons.center_focus_strong,
            onSelected: () {}),
        MenuItem(
          label: 'Reset Zoom',
          icon: Icons.zoom_in,
          onSelected: () {},
        ),
        //const MenuDivider(),
        MenuItem.submenu(
          label: 'Добавить',
          icon: Icons.paste,
            items:[
              MenuItem(
                label: 'Параллельно',
                icon: Icons.widgets,
                onSelected: () {},
              ),
              MenuItem(
                label: 'Последовательно',
                icon: Icons.widgets,
                onSelected: () {},
              ),
            ],
        ),
      ];


    return Padding(
      padding: const EdgeInsets.all(5),
      child: Listener(
        behavior: HitTestBehavior.deferToChild,
        onPointerDown: (PointerDownEvent event) {
          if (event.buttons == kSecondaryMouseButton) {

           /* showMenu(context: context,
                position: buttonMenuPosition(event),
                items: [
              PopupMenuItem<int>(
                value: 0,
                child: Text('Working a lot harder'),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Text('Working a lot less'),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Text('Working a lot smarter'),
              ),
            ]);*/
            createAndShowContextMenu(
              context,
              entries: editorContextMenuEntries,
              position: event.position,
            );
          }
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
          ],
        ),
      ),
    );
  }
  RelativeRect buttonMenuPosition(PointerDownEvent event) {
    final RenderBox bar = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
    Overlay.of(context).context.findRenderObject() as RenderBox;
    const Offset offset = Offset.zero;
    final RelativeRect rect = RelativeRect.fromRect(Rect.fromPoints(event.localPosition,event.position),
      //offset & overlay.size,);
    offset &overlay.size,
    );
    /*final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        bar.localToGlobal(
            bar.size.centerRight(offset),
            ancestor: overlay),
        bar.localToGlobal(
             bar.size.centerRight(offset),
            ancestor: overlay),
      ),
      offset & overlay.size,
    );*/
    return rect;
  }
  List<ContextMenuEntry> createSubmenuEntries() {
    List<ContextMenuEntry> list = [
      MenuItem(
        label: 'Параллельно',
        icon: Icons.widgets,
        onSelected: () {},
      ),
      MenuItem(
        label: 'Последовательно',
        icon: Icons.widgets,
        onSelected: () {},
      ),
    ];
    return list;
  }
}
