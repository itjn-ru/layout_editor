import 'package:flutter/material.dart';
import 'package:collection/collection.dart' show DeepCollectionEquality;
import 'package:uuid/uuid.dart';

import '../controller/events.dart';
import '../controller/layout_model_controller.dart';
import '../item.dart';
import '../layout_model.dart';
import '../screen_size_enum.dart';
import 'grid_background_widget.dart';
import 'layout_model_provider.dart';
import 'resizable_draggable_widget.dart';
import 'screensize_provider.dart';

class MainCanvas extends StatefulWidget {
  final BoxConstraints constraints;
  const MainCanvas({
    super.key,
    required this.constraints,
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

  /// The transformation controller for the interactive viewer.
  final TransformationController _transform = TransformationController();

  /// The scale factor for the canvas, calculated based on the screen size.
  double scaleFactor = 1.0;

  /// The scale size for the viewport, used to zoom in and out.
  /// This is updated when the user interacts with the canvas.
  double scaleSize = 1;
  double cellWidth = 20;
  double cellHeight = 20;
  bool onIteraction = false;
  late Rect viewport;
  late LayoutModel layoutModel;
  Function deepEq = const DeepCollectionEquality().equals;
  bool changed = false;
  late BoxConstraints oldConstraints;
  late final LayoutModelController controller;

  late final ScreenSizeEnum screenSize;
  @override
  void initState() {
    oldConstraints = widget.constraints;

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = LayoutModelControllerProvider.of(context);
    screenSize = ScreenSizeProvider.of(context);
    layoutModel = controller.layoutModel;
    _recalculateScale();
  }

  void _recalculateScale() {
    _canvasWidth = widget.constraints.maxWidth - 20;
    _canvasHeight = widget.constraints.maxHeight - 20;
    scaleFactor = _canvasWidth / screenSize.width;
    cellWidth = 20 * scaleFactor;
    cellHeight = 20 * scaleFactor;
    viewport = Rect.fromLTRB(0, 0, _canvasWidth, _canvasHeight);
  }

  @override
  void dispose() {
    _transform.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        color: Colors.grey.shade50,
        margin: const EdgeInsets.all(10),
        child: InteractiveViewer.builder(
            panEnabled: true,
            transformationController: _transform,
            onInteractionStart: (details) {},
            onInteractionUpdate: (details) {
              _onPanUpdate(details.focalPointDelta);
              controller.eventBus.emit(PanEnd(id: const Uuid().v4()));
            },
            onInteractionEnd: (scaleEndDetails) {
              scaleSize = _transform.value.getMaxScaleOnAxis();
              controller.viewportZoom = scaleSize;
              controller.eventBus.emit(PanEnd(id: const Uuid().v4()));
            },
            minScale: 1,
            maxScale: 8,
            builder: (BuildContext context, quad) {
              return SizedBox.fromSize(
                key: ValueKey('${_canvasWidth}_${_canvasHeight}'),
                // key: UniqueKey(),
                size: viewport.size,
                child: ValueListenableBuilder<Set<String?>>(
                    valueListenable: controller.changedItems,
                    builder: (context, updatedItemIds, _) {
                      final curPage = layoutModel.getCurPage;
                      final list = List.generate(curPage.items.length, (index) {
                        final item = layoutModel.getCurPage.items[index];
                        return _ItemUpdateScope(
                          itemId: item.id,
                          updatedItemIds: updatedItemIds,
                          child: ValueListenableBuilder<String?>(
                              valueListenable: controller.selectedIdNotifier,
                              builder: (context, selectedId, _) {
                                return ResizableDraggableWidget(
                                  key: ValueKey(item.id),
                                  position: Offset(
                                      item["position"]?.dx * scaleFactor ?? 0,
                                      item["position"]?.dy * scaleFactor ?? 0),
                                  initWidth:
                                      item["size"]?.width * scaleFactor ??
                                          _canvasWidth,
                                  initHeight:
                                      item["size"]?.height * scaleFactor ?? 50,
                                  cellWidth: cellWidth / 2,
                                  cellHeight: cellHeight / 2,
                                  canvasWidth: _canvasWidth,
                                  canvasHeight: _canvasHeight,
                                  bgColor: Colors.white,
                                  squareColor: Colors.blueAccent,
                                  scaleConstraints: scaleFactor,
                                  child: item,
                                  selected: selectedId == item.id,
                                );
                              }),
                        );
                      });
                      return Stack(children: [
                        Positioned.fill(
                          child: GridBackgroundBuilder(
                            quad: quad,
                            cellHeight: cellHeight,
                            cellWidth: cellWidth,
                            canvasWidth: _canvasWidth,
                          ),
                        ),
                        ...list,
                        // ...templateWidgets,
                      ]);
                    }),
                // }),
              );
            }),
      ),
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

class _ItemUpdateScope extends StatelessWidget {
  final String itemId;
  final Widget child;
  final Set<String?> updatedItemIds;
  const _ItemUpdateScope({
    required this.itemId,
    required this.child,
    required this.updatedItemIds,
  });

  @override
  Widget build(BuildContext context) {
    final controller = LayoutModelControllerProvider.of(context);
    final shouldUpdate = updatedItemIds.contains(itemId);
// Отметим как обработанный после перерисовки
    if (shouldUpdate) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.markItemAsHandled(itemId);
      });

      // Перерисовываем — данные изменились
      return child;
    }
    // Здесь RepaintBoundary помогает избежать лишней перерисовки,
    // если это просто был ChangeItem, но не относящийся к этому item
    final last = controller.lastEvent;

    final isIsolated = last is ChangeItem;
    return isIsolated ? RepaintBoundary(child: child) : child;
  }
}
