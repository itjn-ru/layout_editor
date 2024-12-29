import 'package:flutter/widgets.dart';
import 'component.dart';
import 'component_table.dart';
import 'source.dart';
import 'style.dart';
import 'style_element.dart';
import 'style_element_widget.dart';
import 'source_table.dart';
import 'source_table_widget.dart';
import 'source_variable.dart';
import 'source_variable_widget.dart';

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
