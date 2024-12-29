import 'package:flutter/material.dart';
import '../component.dart';
import '../component_widget.dart';
import '../item.dart';
import '../layout_model.dart';
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
    this.changed,
    required this.delete,
    required this.switchActive,
    required this.canvasWidth,
    required this.canvasHeight,
    required this.layoutModel,
    this.cellWidth = 10.0,
    this.cellHeight = 10.0,
    required this.position,
    this.deActive,
  });

  ///Начальня ширина, по умолчанию ширина canvas
  final double? initWidth;

  ///Начальная высота, по умолчанию 60
  final double? initHeight;
  final double cellWidth;
  final double cellHeight;
  final Offset position;
  final Item? child;
  final Color? squareColor;
  final Color? bgColor;
  final Function(double width, double height, Offset tranformOffset)? changed;
  final double canvasHeight;
  final double canvasWidth;
  final Function(Key index)? delete;
  final Function(Key index)? switchActive;
  final Function(Key index)? deActive;
  final LayoutModel layoutModel;

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
  Color? _sqColor;
  Color? _bgColor;
  bool _showSquare = true;
  double scale = 1.0;

/*late Item component;
late final curComponentItem;*/
  @override
  void initState() {
    trW = widget.position.dx ?? 0;
    trH = widget.position.dy ?? 0;

    trLastH = trH;
    trLastW = trW;
    trW = (trW / widget.cellWidth).round() * widget.cellWidth;
    trH = (trH / widget.cellHeight).round() * widget.cellHeight;
    _dynamicH = widget.initHeight!;
    _dynamicW = widget.initWidth ?? widget.canvasWidth;
    _dynamicSW = _dynamicW;
    _dynamicSH = _dynamicH;
    _child = IgnorePointer(
        child: ComponentWidget.create(
            widget.child as LayoutComponent, widget.layoutModel));
    _sqColor = widget.squareColor == null ? Colors.white : widget.squareColor!;
    _bgColor = widget.bgColor == null ? Colors.amber : widget.bgColor!;
    if (widget.layoutModel.curItem == widget.child) {
      // context.read<ActiveWidgetProvider>().activeKey = widget.key!;
      _showSquare = true;
    } else {
      _showSquare = false;
    }
    /* if (context.read<ActiveWidgetProvider>().activeKey == widget.key) {
      context.read<LayoutModel>().curItem = widget.child!;
      _showSquare = true;
    } else {
      _showSquare = false;
    }*/
    super.initState();

    // if(_showSquare) context.read<LayoutModel>().curComponentItem=widget.child!;
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

  Offset _panStartOffset = const Offset(0, 0);
  Offset _panUpdateOffset = const Offset(0, 0);
  Offset _panIntervalOffset = const Offset(0, 0);

  panResizeSquare(Alignment dir) {
    return GestureDetector(
      onPanStart: (details) {
        _panStartOffset = details.localPosition;
        _dynamicSW = _dynamicW;
        _dynamicSH = _dynamicH;
      },
      onPanUpdate: (details) {
        //_panUpdateOffset = details.localPosition;
        ///Если выходит за границы
        ///Offset intervalOffset =
        //                   details.localPosition - startMoveOffset + endMoveOffset;
        setState(() {
          _panUpdateOffset = Offset(
              details.localPosition.dx.clamp(
                  0 +
                      _panStartOffset.dx -
                      (dir == Alignment.centerRight
                          ? widget.canvasWidth
                          : widget.canvasWidth),
                  widget.canvasWidth - _panStartOffset.dx.abs() - trLastW),
              details.localPosition.dy.clamp(
                  0 +
                      _panStartOffset.dy -
                      (dir == Alignment.bottomCenter
                          ? widget.canvasHeight
                          : widget.canvasHeight),
                  widget.canvasHeight - _panStartOffset.dy.abs() - trLastH));
        });
        if (dir == Alignment.centerRight || dir == Alignment.centerLeft) {
          if (dir == Alignment.centerRight) {
            _panIntervalOffset = -_panUpdateOffset + _panStartOffset;
          } else if (dir == Alignment.centerLeft) {
            _panIntervalOffset = _panUpdateOffset - _panStartOffset;
          }
          refreshW(dir, _panIntervalOffset.dx);
        } else if (dir == Alignment.bottomCenter) {
          _panIntervalOffset = -_panUpdateOffset + _panStartOffset;
          refreshH(dir, _panIntervalOffset.dy);
        } else if (dir == Alignment.topCenter) {
          _panIntervalOffset = _panUpdateOffset - _panStartOffset;
          refreshH(dir, _panIntervalOffset.dy);
        }

        /*else {
          if (dir == Alignment.bottomRight) {
            _panIntervalOffset = -_panUpdateOffset + _panStartOffset;
            refreshW(dir, _panIntervalOffset.dx);
            refreshH(dir, _panIntervalOffset.dy);
          } else if (dir == Alignment.topRight) {
            _panIntervalOffset = _panUpdateOffset - _panStartOffset;
            refreshW(dir, -_panIntervalOffset.dx);
            refreshH(dir, _panIntervalOffset.dy);
          } else if (dir == Alignment.bottomLeft) {
            _panIntervalOffset = -_panUpdateOffset + _panStartOffset;
            refreshW(dir, -_panIntervalOffset.dx);
            refreshH(dir, _panIntervalOffset.dy);
          } else if (dir == Alignment.topLeft) {
            _panIntervalOffset = _panUpdateOffset - _panStartOffset;
            refreshW(dir, _panIntervalOffset.dx);
            refreshH(dir, _panIntervalOffset.dy);
          }*/

        if (widget.changed != null) {
          widget.changed!(
              _dynamicW, _dynamicH, updateMoveOffset + Offset(trW, trH));
        }
      },
      onPanEnd: ((details) {
        trLastH = trH;
        _lockH = false;
        trLastW = trW;
        _lockW = false;
      }),
      child: Visibility(
        visible: _showSquare,
        child: Icon(
          color: _sqColor!,
          size: 20,
          Icons.circle_sharp,
        ),
      ),
    );
  }

  Widget getResizeable() {
    return Container(
      color: _bgColor,
      width: _dynamicW <= 0 ? 1 : _dynamicW,
      height: _dynamicH <= 0 ? 1 : _dynamicH,
      child: Stack(alignment: Alignment.center, children: [
        _child!,
        Positioned(
          left: _dynamicW / 2 - 10,
          top: 0,
          child: panResizeSquare(Alignment.topCenter),
        ),
        Positioned(
          left: _dynamicW / 2 - 10,
          bottom: 0,
          child: panResizeSquare(Alignment.bottomCenter),
        ),
        Positioned(
          left: 0,
          top: _dynamicH / 2 - 10,
          child: panResizeSquare(Alignment.centerLeft),
        ),
        Positioned(
          right: 0,
          top: _dynamicH / 2 - 10,
          child: panResizeSquare(Alignment.centerRight),
        ),
        Positioned(
            right: 10,
            top: -10,
            child: IconButton(
                onPressed: () {
                  setState(() {
                    widget.layoutModel.deleteItem(widget.child!);
                  });
                //  widget.delete!(widget.key!);
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
    //_showSquare=context.read<ActiveWidgetProvider>().activeKey==widget.key?true:false;
    //_showSquare = value.curComponentItem==widget.child! ? true : false;
    return Transform.translate(
        offset: updateMoveOffset + Offset(trW, trH),
        child: /* Consumer<ActiveWidgetProvider>(
            builder: (context, activeProvider, child) {
          _showSquare = activeProvider.activeKey == widget.key ? true : false;
          return*/

            GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: getResizeable(),
          onTap: () {
            // print(widget.key);
            //print(context.read<ActiveWidgetProvider>().activeKey);

            widget.layoutModel.curItem = widget.child!;
            if (updateMoveOffset != const Offset(0, 0)) {
              print('TAP!');
              widget.deActive!(widget.key!);
            }
            },
          onPanStart: (details) {
            if (_showSquare) startMoveOffset = details.localPosition;
          },
          onPanUpdate: (details) {
            if (_showSquare) {
              Offset intervalOffset =
                  details.localPosition - startMoveOffset + endMoveOffset;

              ///Если выходит за границы
              /*  intervalOffset = Offset(
                        intervalOffset.dx.clamp(0 - trLastW, widget.canvasWidth - _dynamicW - trLastW),
                        intervalOffset.dy
                            .clamp(0 - trLastH, widget.canvasHeight - _dynamicH - trLastH));*/
              if (intervalOffset.dy < -trLastH) {
                intervalOffset = Offset(intervalOffset.dx, 0 - trLastH);
              }
              setState(() {
                updateMoveOffset = Offset(
                    (intervalOffset.dx / widget.cellWidth).round() *
                        widget.cellWidth,
                    (intervalOffset.dy / widget.cellHeight).round() *
                        widget.cellHeight);
              });
              if (widget.changed != null) {
                widget.child!.properties["position"]?.value =
                    updateMoveOffset + Offset(trW, trH);
                widget.changed!(
                    _dynamicW, _dynamicH, updateMoveOffset + Offset(trW, trH));
              }
            }
          },
          onPanEnd: (details) {
            if (_showSquare) endMoveOffset = updateMoveOffset;
          },
          //);
          //}
        ));
  }
}
