import 'package:flutter/widgets.dart';
import 'package:layout_editor/component.dart';
import 'package:layout_editor/component_table.dart';
import 'package:layout_editor/source.dart';
import 'package:layout_editor/style.dart';
import 'package:layout_editor/style_element.dart';
import 'package:layout_editor/style_element_widget.dart';
import 'package:layout_editor/source_table.dart';
import 'package:layout_editor/source_table_widget.dart';
import 'package:layout_editor/source_variable.dart';
import 'package:layout_editor/source_variable_widget.dart';

import 'component_table_widget.dart';

class StyleWidget extends StatelessWidget {
  final LayoutStyle style;

  StyleWidget(this.style);

  factory StyleWidget.create(LayoutStyle style) {
    switch (style.runtimeType) {
      case StyleElement:
        return StyleElementWidget(style as StyleElement);

      default:
        return StyleElementWidget(style);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: buildWidget(context),
    );
  }

  Widget buildWidget(BuildContext context) {
    return Text(style.type);
  }
  
}
