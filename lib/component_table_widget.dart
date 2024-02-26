import 'package:flutter/widgets.dart';
import 'package:layout_editor/component_table.dart';
import 'package:layout_editor/component_widget.dart';
import 'package:layout_editor/item.dart';

class ComponentTableWidget extends ComponentWidget {
  ComponentTableWidget(component) : super(component);

  @override
  Widget buildWidget(BuildContext context) {
    Map<int, TableColumnWidth> columnWidths = {};
    int columnWidthIndex = 0;

    var columns = component.items.whereType<ComponentTableColumn>();

    for (var column in columns) {
      columnWidths[columnWidthIndex] =
          FixedColumnWidth(column["width"] as double);
      columnWidthIndex++;
    }

    List<TableRow> tableRows = [];

    var rowGroups =
        component.items.whereType<ComponentTableRowGroup>();

    for (var rowGroup in rowGroups) {

      var rows = rowGroup.items.whereType<ComponentTableRow>();

      for (var row in rows) {
        List<TableCell> tableCells = [];

        var cells = row.items.whereType<ComponentTableCell>();

        for (Item cell in cells) {
          String cellText = cell["source"]?.isNotEmpty ?? false
              ? "\$" + cell["source"] ?? ""
              : "";
          if (cellText.isEmpty) {
            cellText = cell["text"] ?? "";
          }

          tableCells.add(TableCell(
            child: Container(
                //height: row.height,
                decoration: BoxDecoration(
                  border: Border.all(),
                  color: cell["color"],
                ),
                alignment: cell["alignment"],
                child: Text(cellText,
                    style: TextStyle(
                      fontSize: cell["fontSize"],
                      fontWeight: cell["fontWeight"],
                    ))),
          ));
        }

        tableRows.add(TableRow(children: tableCells));
      }
    }
    return Table(columnWidths: columnWidths, children: tableRows);
  }
}
