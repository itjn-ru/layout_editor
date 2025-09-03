import 'package:flutter/widgets.dart';

import 'process_widget.dart';

class ProcessElementWidget extends ProcessWidget {
  const ProcessElementWidget(super.process, {super.key});

  @override
  Widget buildWidget(BuildContext context) {
    var cellText = process["name"] ?? "";

    return Container(
        child: Text(cellText));
  }
}
