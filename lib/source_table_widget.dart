import 'package:flutter/widgets.dart';
import 'package:layout_editor/component_table.dart';
import 'package:layout_editor/component_widget.dart';
import 'package:layout_editor/item.dart';
import 'package:layout_editor/source_table.dart';
import 'package:layout_editor/source_widget.dart';

class SourceTableWidget extends SourceWidget {
  SourceTableWidget(source) : super(source);

  @override
  Widget buildWidget(BuildContext context) {


    var columns = source.items.whereType<SourceTableColumn>();

    List<TableRow> tableRows = [];

    for (var column in columns) {
      List<TableCell> tableCells = [];


        var cellText = column["name"] ?? "";


      tableCells.add(TableCell(
        child: Container(
            //height: row.height,
            //decoration: BoxDecoration(
            //  border: Border.all(),
            //  color: column["color"],
            //),
            //alignment: column["alignment"],
            child: Text(cellText,
                //style: TextStyle(
                  //fontSize: column["fontSize"],
                  //fontWeight: column["fontWeight"],
                //)
        )),
      ));

      tableRows.add(TableRow(children: tableCells));
    }
    return Table(children: tableRows);

    /*var columns = source.items.whereType<SourceTableColumn>();




    return Column(children: List.generate(columns.length, (index) {
      var column = columns.elementAt(index);
      return Text(column.properties["name"]?.value as String);
    }),);*/
  }
}
