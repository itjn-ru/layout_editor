import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:layout_editor/item.dart';
import 'package:layout_editor/layout_model.dart';
import 'package:layout_editor/page.dart';
import 'package:layout_editor/root.dart';
import 'package:provider/provider.dart';

import 'menu.dart';

class Items extends StatefulWidget {
final Item _item;

  void Function(Item item)? onItemChanged;

  Items(this._item, {this.onItemChanged, super.key});

  @override
  State<StatefulWidget> createState() {
    return ItemsState();
  }
}

class ItemsState extends State<Items> with AutomaticKeepAliveClientMixin {
  //late Item curItem;

  late LayoutModel layoutModel;

  @override
  void initState() {
    super.initState();

    //var layoutModel = context.read<LayoutModel>();

    //curItem = widget._item;// layoutModel.curItem!;
  }

  @override
  Widget build(BuildContext context) {

    super.build(context);

    layoutModel = context.read<LayoutModel>();



    return Container(
      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1))),
      child: _buildItem(widget._item),
    );
  }

  _buildItem(Item item) {
    Widget child;

    if (item.items.isNotEmpty) {
      var children = <Widget>[];
      children.add(
        //Row(
        //children: [
        /*IconButton(iconSize: 12,
            onPressed: () {},
            icon: const Icon(Icons.add),
          ),
          IconButton(iconSize: 12,
            onPressed: () {},
            icon: const Icon(Icons.delete),
          ),*/
        ItemWidget(item), //Text(item["name"]),
        //],
        //)
      );

      var items = item is Root
          ? item.items.whereType<ComponentPage>().toList()
          : item.items;

      children.addAll(List.generate(
        items.length,
        (index) => Padding(
            padding: index == items.length - 1
                ? EdgeInsets.zero
                : EdgeInsets.only(bottom: /*item is Root ? 25 :*/ 5),
            child: _buildItem(items[index])),
      ));
      children.add(Row(
        children: [
          Text(item["name"]),
        ],
      ));

      child = Column(children: children);
    } else {
      child = //Row(
          //children: [
          /*IconButton(iconSize: 12,
            onPressed: () {},
            icon: const Icon(Icons.add),
          ),
          IconButton(iconSize: 12,
            onPressed: () {},
            icon: const Icon(Icons.delete),
          ),*/
          ItemWidget(item); //, //Text(item["name"]),
      //],
      //);
    }

    //var layoutModel = context.read<LayoutModel>();
    var curPageType = switch(widget._item.runtimeType) {
      SourcePage => SourcePage,
      StylePage => StylePage,
      _ => ComponentPage
    };

    var curItem = layoutModel.curItemOnPage[curPageType];


    //print(layoutModel.curItem);
    //print(item);

    return InkWell(
      child: Container(
        padding: const EdgeInsets.only(left: 5, bottom: 5, right: 0, top: 5),
        /*const EdgeInsets.all(5),*/
        decoration: BoxDecoration(
          color: item == curItem
              ? Colors.amber
              : item is ComponentAndSourcePage
                  ? Colors.grey
                  : Colors.white,
          border: const Border(
              top: BorderSide(width: 1),
              left: BorderSide(width: 1),
              bottom: BorderSide(width: 1)),
          /*Border.all(width: 1),*/
        ),
        child: child,
      ),
      onTap: () {
        if (item == curItem) {
          return;
        }

        setState(() {
          layoutModel.curItem = item;

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

  const ItemWidget(this._item, {super.key});

  @override
  State<StatefulWidget> createState() => ItemWidgetState();
}

class ItemWidgetState extends State<ItemWidget> {
  late bool hover;

  @override
  void initState() {
    super.initState();
    hover = false;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    if (hover) {
      children = [
        Text(widget._item['name']),
        const Spacer(),
        /*InkWell(
          child: const Padding(
            padding: EdgeInsets.only(left: 5),
            child: Icon(
              Icons.add,
              size: 18,
            ),
          ),
          onTap: () {},
        ),
        InkWell(
          child: const Padding(
            padding: EdgeInsets.only(left: 5),
            child: Icon(
              Icons.delete,
              size: 18,
            ),
          ),
          onTap: () {},
        ),*/

        InkWell(
          child: const Padding(
            padding: EdgeInsets.only(left: 5, right: 15),
            child: Icon(
              Icons.more_vert,
              size: 18,
            ),
          ),
          onTapDown: (details) {
            var layoutModel = context.read<LayoutModel>();

            var menu = ComponentAndSourceMenu.create(layoutModel, widget._item);

            var menuItems = menu.getComponentMenu(
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
      ];
    } else {
      children = [
        Text(widget._item['name']),
      ];
    }

    return MouseRegion(
      child: Row(children: children),
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

    /*return InkWell(
      child: Text(hover.toString()),

      onTap: () {
      },

      onHover: (value) {
        setState(() {
          hover = value;
        });
      },
    );*/
  }
}

/*
class GridPositionPage extends StatefulWidget {
  @override
  _GridPositionPageState createState() => _GridPositionPageState();
}

class _GridPositionPageState extends State<GridPositionPage> {

  // ↓ hold tap position, set during onTapDown, using getPosition() method
  Offset tapXY;
  // ↓ hold screen size, using first line in build() method
  RenderBox overlay;

  @override
  Widget build(BuildContext context) {
    // ↓ save screen size
    overlay = Overlay.of(context).context.findRenderObject();

    return BaseExamplePage(
      title: 'Grid Position',
      child: GridView.count(
        crossAxisCount: 2,
        children: List.generate(100, (index) {
          return Center(
            child: InkWell(
              child: Text(
                'Item $index',
                style: Theme.of(context).textTheme.headline5,
              ),
              // ↓ save screen tap position now
              onTapDown: getPosition,
              onLongPress: () => showMenu(
                  context: context,
                  position: relRectSize,
                  items: [
                    PopupMenuItem(
                      child: FlatButton.icon(
                        label: Text('Delete'),
                        icon: Icon(Icons.delete),
                      ),
                    )
                  ]
              ),
            ),
          );
        }),
      ),
    );
  }

  // ↓ create the RelativeRect from size of screen and where you tapped
  RelativeRect get relRectSize => RelativeRect.fromSize(tapXY & const Size(40,40), overlay.size);

  // ↓ get the tap position Offset
  void getPosition(TapDownDetails detail) {
    tapXY = detail.globalPosition;
  }
}
 */
