import 'package:flutter/material.dart';
import '../component.dart';
import '../component_widget.dart';
import '../controller/events.dart';
import '../item.dart';
import '../property.dart';
import 'layout_model_provider.dart';
import 'resizable_draggable_widget_platform_interface.dart';

///Возвращает изменяемый виджет

class ResizableDraggableWidget extends StatefulWidget {
  const ResizableDraggableWidget({
    super.key,
    this.initWidth,
    this.initHeight = 60,
    this.child,
    this.bgColor,
    this.squareColor,
    // this.changed,
    required this.canvasWidth,
    required this.canvasHeight,
    required this.scaleConstraints,
    this.cellWidth = 10.0,
    this.cellHeight = 10.0,
    required this.position,
    required this.selected,
  });

  ///Начальня ширина, по умолчанию ширина canvas
  final double? initWidth;

  ///Начальная высота, по умолчанию 60
  final double? initHeight;
  final double scaleConstraints;
  final double cellWidth;
  final double cellHeight;
  final Offset position;
  final Item? child;
  final Color? squareColor;

  final Color? bgColor;

  //final Function(double width, double height, Offset transformOffset)? changed;
  final double canvasHeight;
  final double canvasWidth;
  final bool selected;
  @override
  State<ResizableDraggableWidget> createState() =>
      _ResizableDraggableWidgetState();

  Future<String?> getPlatformVersion() {
    return ResizableDraggableWidgetPlatform.instance.getPlatformVersion();
  }
}

class _ResizableDraggableWidgetState extends State<ResizableDraggableWidget> {
  double _dynamicH = 0;
  double _dynamicW = 0;

  double _dynamicSH = 0;
  double _dynamicSW = 0;

  late double trH;
  late double trW;

  double trLastH = 0;
  double trLastW = 0;

  bool _lockH = false;
  bool _lockW = false;

  Widget? _child;
  Color? _bgColor;
  double scale = 1.0;

  late final controller = LayoutModelControllerProvider.of(context);

  @override
  void initState() {
    trW = widget.position.dx;
    trH = widget.position.dy;

    trLastH = trH;
    trLastW = trW;
    trW = (trW / widget.cellWidth).round() * widget.cellWidth;
    trH = (trH / widget.cellHeight).round() * widget.cellHeight;
    _dynamicH = widget.initHeight!;
    _dynamicW = widget.initWidth ?? widget.canvasWidth;
    _dynamicSW = _dynamicW;
    _dynamicSH = _dynamicH;
    _child = ComponentWidget.create(widget.child as LayoutComponent);
    _bgColor = widget.bgColor == null ? Colors.amber : widget.bgColor!;
    super.initState();

    // if(_showSquare) context.read<LayoutModel>().curComponentItem=widget.child!;
  }

  final Offset _panStartOffset = const Offset(0, 0);
  Offset _panUpdateOffset = const Offset(0, 0);
  Offset _panIntervalOffset = const Offset(0, 0);

  Widget panResizeSquare(Alignment alignment) {
    if (!widget.selected) return const SizedBox.shrink();
    return Align(
      alignment: alignment,
      child: GestureDetector(
        onPanUpdate: (details) => _onResize(details, alignment),
        onPanEnd: (details) => _onEndResize(details),
        behavior:
            HitTestBehavior.translucent, // чтобы реагировать на всю область
        child: Container(
          width: 40, // увеличенная область для жестов
          height: 40,
          alignment: alignment,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.blue, width: 2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.circle, size: 12, color: Colors.blue),
          ),
        ),
      ),
    );
  }

  Widget getResizeable() {
    return Container(
      // color: _bgColor,
      decoration: BoxDecoration(
        color: _bgColor,
        border: Border.all(
          color: widget.selected ? Colors.red : Colors.transparent,
          width: widget.selected ? 2 : 0,
        ),
      ),
      width: _dynamicW <= 0 ? 1 : _dynamicW,
      height: _dynamicH <= 0 ? 1 : _dynamicH,
      child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            _child!,
            Positioned(
              left: _dynamicW / 2 - 10,
              top: -10,
              child: panResizeSquare(Alignment.topCenter),
            ),
            Positioned(
              left: _dynamicW / 2 - 10,
              bottom: -10,
              child: panResizeSquare(Alignment.bottomCenter),
            ),
            Positioned(
              left: -10,
              top: _dynamicH / 2 - 10,
              child: panResizeSquare(Alignment.centerLeft),
            ),
            Positioned(
              right: -10,
              top: _dynamicH / 2 - 10,
              child: panResizeSquare(Alignment.centerRight),
            ),
            if (widget.selected)
              Positioned(
                  right: 10,
                  top: -10,
                  child: IconButton(
                      onPressed: () {
                        controller.layoutModel.deleteItem(widget.child!);
                        controller.eventBus
                            .emit(RemoveItemEvent(id: widget.child!.id));
                      },
                      icon: const Icon(Icons.delete)))
          ]),
    );
  }

  Offset startMoveOffset = const Offset(0, 0);
  Offset endMoveOffset = const Offset(0, 0);
  Offset updateMoveOffset = const Offset(0, 0);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: updateMoveOffset + Offset(trW, trH),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (widget.selected) {
            controller.select(null);
            return;
          }
          controller.select(widget.child!.id);
        },
        child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanStart: (details) {
              if (widget.selected) startMoveOffset = details.localPosition;
            },
            onPanUpdate: (details) {
              if (!widget.selected) return;

              var intervalOffset =
                  details.localPosition - startMoveOffset + endMoveOffset;

              // Ограничение по вертикали
              if (intervalOffset.dy < -trLastH) {
                intervalOffset = Offset(intervalOffset.dx, -trLastH);
              }

              // Смещение кратно cellWidth и cellHeight
              final snappedOffset = Offset(
                (intervalOffset.dx / widget.cellWidth).round() *
                    widget.cellWidth,
                (intervalOffset.dy / widget.cellHeight).round() *
                    widget.cellHeight,
              );

              setState(() {
                updateMoveOffset = snappedOffset;
              });
              onChanged(
                  _dynamicW, _dynamicH, updateMoveOffset + Offset(trW, trH));
            },
            onPanEnd: (details) {
              if (widget.selected) endMoveOffset = updateMoveOffset;
              controller.eventBus.emit(PanEnd(id: widget.child!.id));
            },
            child: getResizeable()),
      ),
    );
  }

  void onChanged(double width, double height, Offset transformOffset) {
    final offset = Offset(
        (transformOffset.dx / widget.scaleConstraints).round().toDouble(),
        (transformOffset.dy / widget.scaleConstraints).round().toDouble());
    widget.child?.properties["position"]?.value = offset;
    controller.updateProperty(
        "position", Property("положение", offset, type: Offset));
    final size =
        Size(width / widget.scaleConstraints, height / widget.scaleConstraints);
    widget.child?.properties["size"]?.value = size;
    controller.updateProperty("size", Property("размер", size, type: Size));
  }

  void _onResize(DragUpdateDetails details, Alignment alignment) {
    setState(() {
      _panUpdateOffset = Offset(
          details.localPosition.dx.clamp(
              0 +
                  _panStartOffset.dx -
                  (alignment == Alignment.centerRight
                      ? widget.canvasWidth
                      : widget.canvasWidth),
              widget.canvasWidth - _panStartOffset.dx.abs() - trLastW),
          details.localPosition.dy.clamp(
              0 +
                  _panStartOffset.dy -
                  (alignment == Alignment.bottomCenter
                      ? widget.canvasHeight
                      : widget.canvasHeight),
              widget.canvasHeight - _panStartOffset.dy.abs() - trLastH));
    });
    if (alignment == Alignment.centerRight ||
        alignment == Alignment.centerLeft) {
      if (alignment == Alignment.centerRight) {
        _panIntervalOffset = -_panUpdateOffset + _panStartOffset;
      } else if (alignment == Alignment.centerLeft) {
        _panIntervalOffset = _panUpdateOffset - _panStartOffset;
      }
      refreshW(alignment, _panIntervalOffset.dx);
    } else if (alignment == Alignment.bottomCenter) {
      _panIntervalOffset = -_panUpdateOffset + _panStartOffset;
      refreshH(alignment, _panIntervalOffset.dy);
    } else if (alignment == Alignment.topCenter) {
      _panIntervalOffset = _panUpdateOffset - _panStartOffset;
      refreshH(alignment, _panIntervalOffset.dy);
    }
    onChanged(_dynamicW, _dynamicH, updateMoveOffset + Offset(trW, trH));
  }

  void _onEndResize(DragEndDetails details) {
    trLastH = trH;
    _lockH = false;
    trLastW = trW;
    _lockW = false;
    controller.eventBus.emit(PanEnd(id: widget.child!.id));
  }

  refreshW(Alignment dir, double dx) {
    if (_dynamicW < 20 && _panIntervalOffset.dx > 0) {
      _lockW = true;
      _dynamicW = 20;
    }

    if (_panIntervalOffset.dx < 0) {
      _lockW = false;
    }
    if (!_lockW) {
      setState(() {
        // dx < 0
        // ? _dynamicW = (_dynamicSW - dx).clamp(-_dynamicSW - trLastW-trW, widget.canvasWidth)
        // ? _dynamicW = (_dynamicSW - dx).clamp(20, widget.canvasWidth - trLastW)
        _dynamicW = (_dynamicSW - dx).clamp(20, widget.canvasWidth);
        _dynamicW = (_dynamicW / widget.cellWidth).round() * widget.cellWidth;
        if (dir == Alignment.centerLeft ||
            dir == Alignment.topLeft ||
            dir == Alignment.bottomLeft) {
          trW = dx + trLastW;
          trW = (trW / widget.cellWidth).round() * widget.cellWidth;
        }
      });
    }
  }

  refreshH(Alignment dir, double dy) {
    if (_dynamicH < 20 && _panIntervalOffset.dy > 0) {
      _lockH = true;
      _dynamicH = 20;
    }
    if (_panIntervalOffset.dy < 0) {
      _lockH = false;
    }

    if (!_lockH) {
      setState(() {
        dy < 0
            ? _dynamicH = (_dynamicSH - dy)
                .clamp(-_dynamicSH - trLastH, widget.canvasHeight)
            : _dynamicH = (_dynamicSH - dy).clamp(20, widget.canvasHeight);
        // _dynamicH = (_dynamicSH - dy);
        _dynamicH = (_dynamicH / widget.cellHeight).round() * widget.cellHeight;
        if (dir == Alignment.topCenter ||
            dir == Alignment.topLeft ||
            dir == Alignment.topRight) {
          trH = dy + trLastH;
          trH = (trH / widget.cellHeight).round() * widget.cellHeight;
        }
      });
    }
  }
}
