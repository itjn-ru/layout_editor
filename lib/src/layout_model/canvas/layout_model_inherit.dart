import 'package:flutter/material.dart';

import '../layout_model.dart';

class LayoutModelInheritedWidget extends InheritedWidget {
  const LayoutModelInheritedWidget({super.key,required this.child,required this.layoutModel}) : super(child: child);

  final Widget child;

  final LayoutModel layoutModel;

  static LayoutModelInheritedWidget of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LayoutModelInheritedWidget>()!;
  }

  @override
  bool updateShouldNotify(LayoutModelInheritedWidget oldWidget) {
    return oldWidget.layoutModel != layoutModel;
  }
}