import 'package:flutter/material.dart';
import 'package:collection/collection.dart' show DeepCollectionEquality;

import '../component.dart';
import '../component_widget.dart';
import '../components_and_sources.dart';
import '../item.dart';
import '../layout_model.dart';
import 'grid_background_widget.dart';
import 'resizable_draggable_widget.dart';

class MainCanvas extends StatefulWidget {
  final BoxConstraints constraints;
  final List<Item> items;
  final LayoutModel layoutModel;
  final ScreenSizeEnum screenSize;
  const MainCanvas({
    super.key,
    required this.layoutModel,
    required this.items,
    required this.constraints,
    required this.screenSize,
  });

  @override
  State<MainCanvas> createState() => _MainCanvasState();
}

class _MainCanvasState extends State<MainCanvas> {
  List<Widget> templateWidgets = [];
  List<Item> items = [];
  List<Widget> components = [];
  double wrappedWidth = 0;
  double wrappedHeight = 0;
  Offset position = const Offset(0, 0);
  late double _canvasHeight;
  late double _canvasWidth ;
  final TransformationController _transform = TransformationController();
  double scaleConstraints = 1.0;
  double scaleSize = 1;
  double cellWidth = 20;
  double cellHeight = 20;
  bool onIteraction = false;
  Key activeWidget = UniqueKey();
  late Rect viewport;
  GlobalKey globalKey = GlobalKey();
  late LayoutModel layoutModel;
  Function deepEq = const DeepCollectionEquality().equals;
  bool changed = false;
late BoxConstraints oldConstraints;
  @override
  void initState() {
    oldConstraints=widget.constraints;
    _canvasWidth = widget.constraints.maxWidth-20;
    _canvasHeight = widget.constraints.maxHeight-20;
    scaleConstraints = _canvasWidth / widget.screenSize.width;
    cellWidth = cellWidth * scaleConstraints;
    cellHeight = cellHeight * scaleConstraints;
    viewport = Rect.fromLTRB(0, 0, _canvasWidth, _canvasHeight);
    super.initState();
  }

  @override
  void dispose() {
    _transform.dispose();
    super.dispose();
  }

   @override
  Widget build(BuildContext context) {
    // templateWidgets = _initWidgetList();
     if((oldConstraints.maxWidth-widget.constraints.maxWidth).abs()>10) {
       oldConstraints=widget.constraints;
       _canvasWidth = widget.constraints.maxWidth-20;
       _canvasHeight = widget.constraints.maxHeight-20;
       scaleConstraints = _canvasWidth / widget.screenSize.width;
       cellWidth = cellWidth * scaleConstraints.truncateToDouble();
       cellHeight = cellHeight * scaleConstraints.truncateToDouble();
       viewport = Rect.fromLTRB(0, 0, _canvasWidth, _canvasHeight);
     }
    if (!onIteraction) {
      items = widget.items;
      templateWidgets = _initWidgetList();
    }
    /* if(!deepEq(widget.items,items)||changed) {

      items = widget.items;
      templateWidgets = _initWidgetList();
      setState(() {
        changed=false;
      });
    }*/

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: DragTarget<Widget>(
          builder: (
            BuildContext context,
            List<dynamic> accepted,
            List<dynamic> rejected,
          ) {
            return Container(
              color: Colors.grey.shade50,
              width: _canvasWidth,
              height: _canvasHeight,
              child: InteractiveViewer.builder(
                  panEnabled: true,
                  transformationController: _transform,
                  onInteractionStart: (details) {
                    /*  context.read<ActiveWidgetProvider>().activeKey =
                            activeWidget;*/
                  },
                  onInteractionUpdate: (details) {
                    setState(() {
                      onIteraction = true;
                    });
                    _onPanUpdate(details.focalPointDelta);
                  },
                  onInteractionEnd: (scaleEndDetails) {
                    scaleSize = _transform.value.getMaxScaleOnAxis();

                    setState(() {
                      onIteraction = false;
                    });
                  },
                  minScale: 1,
                  maxScale: 8,
                  builder: (BuildContext context, quad) {
                    return SizedBox.fromSize(
                      key: UniqueKey(),
                      size: viewport.size,
                      child: //Consumer<LayoutModel>(builder: (_, value, __) {
                          // items = value.curItem.items;
                          //   componentsItems(items);
                          //templateWidgets = _initWidgetList();
                          //return
                          Stack(clipBehavior: Clip.none, children: [
                        Positioned.fill(
                          child: GridBackgroundBuilder(
                            quad: quad,
                            cellHeight: cellHeight,
                            cellWidth: cellWidth,
                            canvasWidth: _canvasWidth,
                          ),
                        ),
                        ...templateWidgets,
                      ]),
                      // }),
                    );
                  }),
            );
          },
          onAcceptWithDetails: (DragTargetDetails<Widget> details) {
            final UniqueKey uniqueKey = UniqueKey();
            //context.read<ActiveWidgetProvider>().activeKey = uniqueKey;
            RenderBox? renderBox =
                globalKey.currentContext?.findRenderObject() as RenderBox;
            final localPosition = renderBox.globalToLocal(details.offset);
            setState(() {
              templateWidgets
                  .add(textField(uniqueKey, localPosition)); //details.data);
            });
          },
        ),
      ),
    );
  }

  void componentsItems(List<Item> componentsItems) {
    components
      ..clear()
      ..addAll(List.generate(
        componentsItems.length, //widget._items.length,
        (index) => ComponentWidget.create(
            componentsItems[index] as LayoutComponent, widget.layoutModel),
      ));
  }

  List<ResizableDraggableWidget> _initWidgetList() {
    final List<ResizableDraggableWidget> _list = [];
    for (final itemChild in items) {
      _list.add(ResizableDraggableWidget(
        key: UniqueKey(),
        position: Offset(itemChild["position"]?.dx * scaleConstraints ?? 0,
            itemChild["position"]?.dy * scaleConstraints ?? 0),
        initWidth: itemChild["size"]?.width * scaleConstraints ?? _canvasWidth,
        initHeight: itemChild["size"]?.height * scaleConstraints ?? 50,
        cellWidth: cellWidth / 2,
        cellHeight: cellHeight / 2,
        canvasWidth: _canvasWidth,
        canvasHeight: _canvasHeight,
        //active: activeWidget == key ? true : false,
        bgColor: Colors.white,
        squareColor: Colors.blueAccent,
        changed: (width, height, tranformOffset) {
          final component = widget.layoutModel.curPage.items
              .firstWhere((e) => e == itemChild);
          component.properties["position"]?.value = Offset(
              (tranformOffset.dx / scaleConstraints).round().toDouble(),
              (tranformOffset.dy / scaleConstraints).round().toDouble());
          component.properties["size"]?.value =
              Size(width / scaleConstraints, height / scaleConstraints);
          /* setState(() {
            position = tranformOffset;
            wrappedHeight = height;
            wrappedWidth = width;
          });*/
        },
        delete: (i) {
          setState(() {
            templateWidgets.removeWhere((e) => e.key == i);
          });
        },
        deActive: (key) {
          setState(() {
            changed = true;
          });
        },
        switchActive: (key) {
          setState(() {
         //   activeWidget = key;
          });
        },
        layoutModel: widget.layoutModel,
        child: itemChild,
      ));
    }
    return _list;
  }

  Widget textField(UniqueKey key, Offset offset) {
    return ResizableDraggableWidget(
      key: key,
      position: offset,
      canvasWidth: _canvasWidth,
      canvasHeight: _canvasHeight,
      cellHeight: cellHeight,
      cellWidth: cellWidth,
      //active: activeWidget == key ? true : false,
      bgColor: Colors.white,
      squareColor: Colors.blueAccent,
      /*changed: (width, height, tranformOffset) {
          setState(() {
            position = tranformOffset;
            wrappedHeight = height;
            wrappedWidth = width;
          });
        },*/
      delete: (i) {
        setState(() {
          templateWidgets.removeWhere((e) => e.key == i);
        });
      },

      switchActive: (key) {
        setState(() {
          activeWidget = key;
        });
      },
      layoutModel: widget.layoutModel,
    );
  }

  void _onPanUpdate(Offset delta) {
    final matrix = _transform.value.clone();
    matrix.translate(delta.dx, delta.dy);
    if (delta.dy < 0) {
      Rect rect =
          Rect.fromLTRB(0, 0, _canvasWidth, viewport.height + delta.dy.abs());
      setState(() {
        viewport = rect;
      });
    }
  }
}

/*class Components extends StatelessWidget {
  const Components({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LayoutModel>(builder: (_, value, __) {
      return Stack(children: templateWidgets);
    });
  }
}*/
