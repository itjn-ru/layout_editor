import 'package:flutter/widgets.dart';
import 'package:layout_editor/component.dart';
import 'package:layout_editor/component_table.dart';
import 'package:layout_editor/source.dart';
import 'package:layout_editor/style_element.dart';
import 'package:layout_editor/style_element_widget.dart';
import 'package:layout_editor/source_table.dart';
import 'package:layout_editor/source_table_widget.dart';
import 'package:layout_editor/source_variable.dart';
import 'package:layout_editor/source_variable_widget.dart';

import 'component_table_widget.dart';

class SourceWidget extends StatelessWidget {
  final LayoutSource source;

  SourceWidget(this.source);

  factory SourceWidget.create(LayoutSource source) {
    switch (source.runtimeType) {
      case SourceVariable:
        return SourceVariableWidget(source as SourceVariable);
      case SourceTable:
        return SourceTableWidget(source as SourceTable);

      default:
        return SourceWidget(source);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: buildWidget(context),
    );
  }

  Widget buildWidget(BuildContext context) {
    return Text(source.type);
  }
}
