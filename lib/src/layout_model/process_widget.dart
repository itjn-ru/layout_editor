import 'package:flutter/widgets.dart';
import 'package:xml_edit/src/layout_model/process.dart';

import 'process_element.dart';
import 'process_element_widget.dart';

class ProcessWidget extends StatelessWidget {
  final LayoutProcess process;

  ProcessWidget(this.process);

  factory ProcessWidget.create(LayoutProcess process) {
    switch (process.runtimeType) {
      case ProcessElement:
        return ProcessElementWidget(process as ProcessElement);

      default:
        return ProcessElementWidget(process);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: buildWidget(context),
    );
  }

  Widget buildWidget(BuildContext context) {
    return Text(process.type);
  }

}
