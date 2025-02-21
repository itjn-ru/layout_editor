import 'package:flutter/material.dart';
import 'package:collection/collection.dart' show DeepCollectionEquality;
import 'package:uuid/uuid.dart';

import '../components_and_sources.dart';
import '../controller/events.dart';
import '../controller/layout_model_controller.dart';
import '../item.dart';
import '../layout_model.dart';
import 'grid_background_widget.dart';
import 'layout_model_inherit.dart';
import 'resizable_draggable_widget.dart';

class MainCanvas extends StatefulWidget {
  final BoxConstraints constraints;
  final List<Item> items;
  final ScreenSizeEnum screenSize;
  final LayoutModelController controller;

  const MainCanvas({
    super.key,
    required this.items,
    required this.constraints,
    required this.screenSize,
    required this.controller,
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
  late double _canvasWidth;

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
    widget.controller.eventBus.events.listen(_handleRunnerEvents);
    oldConstraints = widget.constraints;
    _canvasWidth = widget.constraints.maxWidth - 20;
    _canvasHeight = widget.constraints.maxHeight - 20;
    scaleConstraints = _canvasWidth / widget.screenSize.width;
    cellWidth = cellWidth * scaleConstraints;
    cellHeight = cellHeight * scaleConstraints;
    viewport = Rect.fromLTRB(0, 0, _canvasWidth, _canvasHeight);
    super.initState();
  }

  void _handleRunnerEvents(LayoutModelEvent event) {
    if (mounted && (event is SelectionEvent ||
          event is PanEnd ||
          event is NewProjectEvent)) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _transform.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // templateWidgets = _initWidgetList();
    if ((oldConstraints.maxWidth - widget.constraints.maxWidth).abs() > 10) {
      oldConstraints = widget.constraints;
      _canvasWidth = widget.constraints.maxWidth - 20;
      _canvasHeight = widget.constraints.maxHeight - 20;
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
        child: Container(
          color: Colors.grey.shade50,
          width: _canvasWidth,
          height: _canvasHeight,
          child: InteractiveViewer.builder(
              panEnabled: true,
              transformationController: _transform,
              onInteractionStart: (details) {},
              onInteractionUpdate: (details) {
                /*setState(() {
                  onIteraction = true;
                });*/
                _onPanUpdate(details.focalPointDelta);
                widget.controller.eventBus.emit(PanEnd(id: const Uuid().v4()));
              },
              onInteractionEnd: (scaleEndDetails) {
                scaleSize = _transform.value.getMaxScaleOnAxis();
                widget.controller.viewportZoom=scaleSize;
                widget.controller.eventBus.emit(PanEnd(id: const Uuid().v4()));
                /*setState(() {
                  onIteraction = false;
                });*/
              },
              minScale: 1,
              maxScale: 8,
              builder: (BuildContext context, quad) {
                return SizedBox.fromSize(
                  key: UniqueKey(),
                  size: viewport.size,
                  child: Stack(clipBehavior: Clip.none, children: [
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
        ),
      ),
    );
  }

  List<LayoutModelInheritedWidget> _initWidgetList() {
    final List<LayoutModelInheritedWidget> _list = [];
    for (final itemChild in items) {
      _list.add(LayoutModelInheritedWidget(
        layoutModel: widget.controller.layoutModel,
        child: ResizableDraggableWidget(
          //key: UniqueKey(),
          position: Offset(itemChild["position"]?.dx * scaleConstraints ?? 0,
              itemChild["position"]?.dy * scaleConstraints ?? 0),
          initWidth:
          itemChild["size"]?.width * scaleConstraints ?? _canvasWidth,
          initHeight: itemChild["size"]?.height * scaleConstraints ?? 50,
          cellWidth: cellWidth / 2,
          cellHeight: cellHeight / 2,
          canvasWidth: _canvasWidth,
          canvasHeight: _canvasHeight,
          bgColor: Colors.white,
          squareColor: Colors.blueAccent,
          scaleConstraints: scaleConstraints,
          controller: widget.controller,
          child: itemChild,
        ),
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
      scaleConstraints: scaleConstraints,
      bgColor: Colors.white,
      squareColor: Colors.blueAccent,
      controller: widget.controller,
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
