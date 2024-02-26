import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:layout_editor/component.dart';
import 'package:layout_editor/component_group.dart';
import 'package:layout_editor/component_table.dart';
import 'package:layout_editor/component_text.dart';
import 'package:layout_editor/components_and_sources.dart';
import 'package:layout_editor/form_checkbox.dart';
import 'package:layout_editor/item.dart';
import 'package:layout_editor/page.dart';
import 'package:layout_editor/property.dart';
import 'package:layout_editor/root.dart';
import 'package:layout_editor/source_table.dart';
import 'package:layout_editor/source_variable.dart';

import 'component_and_source.dart';
import 'form_text_field.dart';

class LayoutModel {
  late Root root;
  late ComponentAndSourcePage curPage;

  late Item _curItem;

  Item get curItem => _curItem;

  set curItem(Item value) {
    _curItem = value;

    if (_curItem is Root) {
      curComponent = null;
    } else if (_curItem is ComponentPage) {
      curPage = _curItem as ComponentPage;
      curComponent = null;
    } else if (_curItem is SourcePage) {
      curPage = _curItem as SourcePage;
      curComponent = null;
    } else if (_curItem is LayoutComponentAndSource) {
      curComponent = _curItem as LayoutComponentAndSource;
      curPage = _itemsOnPage[_curItem] as ComponentAndSourcePage;
    } else {
      curComponent = _itemsOnComponent[_curItem];
      curPage = _itemsOnPage[curComponent] as ComponentAndSourcePage;
    }
  }

  LayoutComponentAndSource? curComponent;

  Map<Item, Item> _itemsOnPage = {};
  Map<Item, LayoutComponentAndSource> _itemsOnComponent = {};


  getComponentByItem(Item item) {
    _itemsOnComponent[item];
  }


  LayoutModel() {
    root = Root("макет");
    _curItem = root;
    curPage = ComponentPage("страница");
    root.items.add(curPage);
    root.items.add(SourcePage("страница данных"));
  }

  fromMap(Map map) {
    root = Root(map['properties']['name']);
    root.properties = _propertiesFromMap(map['properties']);
    root.items = _itemsFromMap(root, map['items']);
    curPage =
        root.items.firstWhere((element) => element is ComponentAndSourcePage)
            as ComponentAndSourcePage;
    _curItem = curPage;
  }

  Map<String, Property> _propertiesFromMap(Map map) {
    Map<String, Property> properties = map.map(
      (key, value) {
        return MapEntry(
            key,
            switch (key) {
              "width" =>
                Property("ширина", double.tryParse(value), type: double),
              "position" => Property(
                  "положение",
                  Offset(double.tryParse(value['left']) ?? 0,
                      double.tryParse(value['top']) ?? 0),
                  type: Offset),
              "size" => Property(
                  "размер",
                  Size(double.tryParse(value['width']) ?? 0,
                      double.tryParse(value['height']) ?? 0),
                  type: Size),
              "color" =>
                Property("цвет", Color(int.tryParse(value) ?? 0), type: Color),
              'textStyle' => Property(
                  "стиль текста",
                  TextStyle(
                    fontSize: double.tryParse(value['fontSize']) ?? 0,
                    fontWeight: switch (
                        int.tryParse(value['fontWeight']) ?? 0) {
                      100 => FontWeight.w100,
                      200 => FontWeight.w200,
                      300 => FontWeight.w300,
                      4400 => FontWeight.w300,
                      500 => FontWeight.w500,
                      600 => FontWeight.w600,
                      700 => FontWeight.w700,
                      800 => FontWeight.w800,
                      900 => FontWeight.w900,
                      _ => FontWeight.normal
                    },
                  ),
                  type: TextStyle),
              'alignment' => Property(
                  "выравнивание",
                  Alignment(double.tryParse(value['x']) ?? 0,
                      double.tryParse(value['y']) ?? 0),
                  type: Alignment),
              _ => Property(key, value)
            });
      },
    );
    return properties;
  }

  List<Item> _itemsFromMap(Item parent, List list) {
    List<Item> items = [];

    for (var element in list) {
      Item item = Item("item", "item");
      switch (element['type']) {
        case "componentPage":
          item = ComponentPage("");
        case "sourcePage":
          item = SourcePage("");
        case "group":
          item = ComponentGroup("");
        case "table":
          if (parent is ComponentPage) {
            item = ComponentTable("");
          } else if (parent is SourcePage) {
            item = SourceTable("");
          } else if (parent is ComponentGroup) {
            item = ComponentTable("");
          }
        case "column":
          if (parent is ComponentTable) {
            item = ComponentTableColumn("");
          } else if (parent is SourceTable) {
            item = SourceTableColumn("");
          }
        case "rowGroup":
          item = ComponentTableRowGroup("");
        case "row":
          item = ComponentTableRow("");
        case "cell":
          item = ComponentTableCell("");
        case "text":
          item = ComponentText("");
        case "variable":
          item = SourceVariable("");
        case "textField":
          item = FormTextField("");
        case "checkbox":
          item = FormCheckbox("");
      }

      var itemProperties = _propertiesFromMap(element['properties']);

      item.properties.forEach((key, value) {
        if (itemProperties.containsKey(key)) {
          if (item.properties[key]?.type == itemProperties[key]?.type) {
            itemProperties[key]!.title = item.properties[key]!.title;
            item.properties[key] = itemProperties[key]!;

          }
        }
      });

      item.items = _itemsFromMap(item, element['items']);

      if (item is LayoutComponentAndSource) {
        curComponent = item;
        for (var curItem in item.items) {
          _setComponentForItem(curItem);
        }
      }

      if (item is ComponentAndSourcePage) {
        curPage = item;
        for (var curItem in item.items) {
          _setPageForItem(curItem);
        }
      }

      items.add(item);
    }

    return items;
  }

  Map toMap() {
    Map map = {};

    map['layout'] = {
      'properties': _propertiesToMap(root),
      'items': _itemsToMap(root)
    };

    return map['layout'];
  }

  Map _propertiesToMap(Item item) {
    Map map = {};

    item.properties.forEach((key, property) {
      map[key] = switch (property.type) {
        Offset => {
            'left': property.value.dx.toString(),
            'top': property.value.dy.toString()
          },
        Size => {
            'width': property.value.width.toString(),
            'height': property.value.height.toString()
          },
        Color => property.value.value.toRadixString(16).toUpperCase(),
        TextStyle => {
            'fontSize': property.value.fontSize,
            'fontWeight': property.value.fontWeight.value
          },
        Alignment => {'x': property.value.x, 'y': property.value.y},
        _ => property.value.toString(),
      };
    });

    return map;
  }

  _itemsToMap(Item item) {
    List list = [];

    for (item in item.items) {
      list.add({
        'type': item.type,
        'properties': _propertiesToMap(item),
        'items': _itemsToMap(item)
      });
    }

    return list;
  }

  addItem(Item parent, Item item) {

    var component = getComponentByItem(parent);


    if (item is ComponentPage) {
      var indexLastPage = root.items
          .lastIndexWhere((element) => element.runtimeType == ComponentPage);
      root.items.insert(++indexLastPage, item);
      /*} else if (item is SourcePage) {
      var indexLastPage = root.items
          .lastIndexWhere((element) => element.runtimeType == SourcePage);
      root.items.insert(++indexLastPage, item);*/
    } else if (item is LayoutComponentAndSource) {
      _curItem.items.add(item);
      curComponent = item is ComponentGroup ? null : item;

      _setPageForItem(item);
      _setComponentForItem(item);
    } else {
      if (curComponent == null) {
        return;
      }

      var indexLastItem = _curItem.items
          .lastIndexWhere((element) => element.runtimeType == item.runtimeType);
      _curItem.items.insert(++indexLastItem, item);
      _setComponentForItem(item);

      switch (item.runtimeType) {
        case ComponentTableColumn:
          curComponent!.items
              .where((element) => element.runtimeType == ComponentTableRowGroup)
              .forEach((rowGroup) {
            for (var row in rowGroup.items) {
              var cell = ComponentTableCell("ячейка");
              row.items.add(cell);

              _setComponentForItem(cell);
            }
          });

        case ComponentTableRowGroup:
          var row = ComponentTableRow("строка");
          item.items.add(row);
          _setComponentForItem(row);

          curComponent!.items
              .where((element) => element.runtimeType == ComponentTableColumn)
              .forEach((rowGroup) {
            var cell = ComponentTableCell("ячейка");

            row.items.add(cell);

            _setComponentForItem(cell);
          });
        case ComponentTableRow:
          curComponent!.items
              .where((element) => element.runtimeType == ComponentTableColumn)
              .forEach((rowGroup) {
            var cell = ComponentTableCell("ячейка");

            item.items.add(cell);

            _setComponentForItem(cell);
          });

        default:
      }
    }
  }

  deleteItem(Item item) {
    if (item is ComponentAndSourcePage) {
      root.items.remove(item);
      curPage =
          root.items.firstWhere((element) => element is ComponentAndSourcePage)
              as ComponentAndSourcePage;
      _curItem = root;
    } else if (item is LayoutComponentAndSource) {
      if (curPage.items.contains(item)) {
        curPage.items.remove(item);
        _curItem = curPage;
      } else {
        var groups = curPage.items.whereType<ComponentGroup>();

        for (var group in groups) {
          if (group.items.contains(item)) {
            group.items.remove(item);
            _curItem = group;
            break;
          }
        }
      }

      //if (curPage.items.isEmpty) {
      curComponent = null;
      //} else {
      //  curComponent = curPage.items.first as LayoutComponent;
      //}
    } else {
      if (curComponent == null) {
        return;
      }

      switch (item.runtimeType) {
        case ComponentTableColumn:
          var indexOfColumn = curComponent!.items
              .where((element) => element.runtimeType == ComponentTableColumn)
              .toList()
              .indexOf(item);

          curComponent!.items.remove(item);
          curComponent!.items
              .where((element) => element.runtimeType == ComponentTableRowGroup)
              .forEach((rowGroup) {
            for (var row in rowGroup.items) {
              row.items.removeAt(indexOfColumn);
            }
          });

          _curItem = curComponent!;

        case ComponentTableRowGroup:
          curComponent!.items.remove(item);
          _curItem = curComponent!;
        case ComponentTableRow:
          ComponentTableRowGroup? foundGroup;
          curComponent!.items
              .whereType<ComponentTableRowGroup>()
              .forEach((rowGroup) {
            if (rowGroup.items.where((row) => row == item).isNotEmpty) {
              foundGroup = rowGroup;
            }
          });

          if (foundGroup == null) {
            return;
          }

          foundGroup!.items.remove(item);
          _curItem = foundGroup!;

        case SourceTableColumn:
          curComponent!.items.remove(item);
          _curItem = curComponent!;

        default:
      }
    }
  }

  _setPageForItem(Item item) {
    _itemsOnPage[item] = curPage;

    for (var curItem in item.items) {
      _setPageForItem(curItem);
    }
  }

  _setComponentForItem(Item item) {
    if (curComponent == null) {
      return;
    }
    //_itemsOnComponent[_curComponent!] = _curComponent!;
    _itemsOnComponent[item] = curComponent!;

    for (var curItem in item.items) {
      _setComponentForItem(curItem);
    }
  }
}
