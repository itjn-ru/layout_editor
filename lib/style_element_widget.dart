import 'package:flutter/widgets.dart';
import 'package:layout_editor/component_table.dart';
import 'package:layout_editor/component_widget.dart';
import 'package:layout_editor/item.dart';
import 'package:layout_editor/source_table.dart';
import 'package:layout_editor/source_widget.dart';
import 'package:layout_editor/style_widget.dart';

class StyleElementWidget extends StyleWidget {
  StyleElementWidget(style) : super(style);

  @override
  Widget buildWidget(BuildContext context) {
    var cellText = style["name"] ?? "";

    return Container(
        //height: row.height,
        //decoration: BoxDecoration(
        //  border: Border.all(),
        //  color: column["color"],
        //),
        //alignment: column["alignment"],
        child: Text(
      cellText,
      //style: TextStyle(
      //fontSize: column["fontSize"],
      //fontWeight: column["fontWeight"],
      //)
    ));

    /*var columns = source.items.whereType<SourceTableColumn>();




    return Column(children: List.generate(columns.length, (index) {
      var column = columns.elementAt(index);
      return Text(column.properties["name"]?.value as String);
    }),);*/
  }
}
