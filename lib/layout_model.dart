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
import 'package:layout_editor/style.dart';
import 'package:layout_editor/style_element.dart';
import 'package:uuid_type/uuid_type.dart';

import 'component_and_source.dart';
import 'form_hidden_field.dart';
import 'form_text_field.dart';

class LayoutModel {
  late Root root;
  late ComponentAndSourcePage curPage;

  late Item _curItem;
  late Item _curComponentItem;
  late Item _curSourceItem;
  late Item _curStyleItem;

  late Type curPageType;

  Item get curItem {
    //return _curItem;

    return curItemOnPage[curPageType]!;

    /*switch (curPage.runtimeType) {
      case ComponentPage:
        return _curComponentItem;
      case SourcePage:
        return _curSourceItem;
      case StylePage:
        return _curStyleItem;
      default:
        return _curItem;
    }*/
  }

  set curItem(Item value) {
    _curItem = value;

    curItemOnPage[curPageType] = value;

    /*
    if (_curItem is Root) {
    } else if (_curItem is ComponentAndSourcePage) {
      curPage = _curItem as ComponentAndSourcePage;
    } else if (_curItem is LayoutComponentAndSource) {
      curPage = _itemsOnPage[_curItem] as ComponentAndSourcePage;
    } else {
      curPage = _itemsOnPage[_curItem] as ComponentAndSourcePage;
    }

    switch (curPage.runtimeType) {
      case ComponentPage:
        _curComponentItem = value;
        break;
      case SourcePage:
        _curSourceItem = value;
        break;
      case StylePage:
        _curStyleItem = value;
        break;
    }*/
  }

  //LayoutComponentAndSource? curComponent;

  List<Style> get styles {
    var styleList = <Style>[];

    var stylePage = root.items.whereType<StylePage>().first;

    var list = stylePage.items.whereType<StyleElement>();

    for (var style in list) {
      styleList.add(Style(style['id'], style['name']));
    }
    return styleList;
  }

  StyleElement? getStyleElementById(Uuid id) {
    var stylePage = root.items.whereType<StylePage>().first;

    var list = stylePage.items.whereType<StyleElement>();

    return list.where((element) => element['id'] == id).firstOrNull;
  }

  final Map<Item, ComponentAndSourcePage> _itemsOnPage = {};
  final Map<Item, LayoutComponentAndSource> _itemsOnComponent = {};
  final Map<Type, Item> curItemOnPage = {};

  LayoutComponentAndSource? getComponentByItem(Item item) {
    if (item is LayoutComponentAndSource) {
      return item;
    }

    return _itemsOnComponent[item];
  }

  ComponentAndSourcePage? getPageByItem(Item item) {
    if (item is Root) {
      return item.items.whereType<ComponentPage>().first;
    }

    if (item is ComponentAndSourcePage) {
      return item;
    }

    return _itemsOnPage[item];
  }

  LayoutModel() {
    root = Root("макет");
    curPage = ComponentPage("страница");
    curPageType = ComponentPage;
    //curItem = root;

    curItemOnPage[ComponentPage] = root;

    root.items.add(curPage);

    var sourcePage = SourcePage("страница данных");
    root.items.add(sourcePage);
    curItemOnPage[SourcePage] = sourcePage;

    var stylePage = StylePage("страница стилей");
    root.items.add(stylePage);
    curItemOnPage[StylePage] = stylePage;

    StyleElement basicElement = StyleElement("базовый стиль");
    basicElement.properties['id'] =
        Property("идентификатор", Uuid.nil, type: Uuid);
    stylePage.items.add(basicElement);
    //curItemOnPage[StylePage] = basicElement;
    _setPageForItem(stylePage, basicElement);
  }

  fromMap(Map map) {
    root = Root(map['properties']['name']);
    root.properties = _propertiesFromMap(map['properties']);
    root.items = _itemsFromMap(root, map['items']);
    curItem = root;
    curItemOnPage[ComponentPage] = root;

    if (root.items.whereType<ComponentPage>().isEmpty) {
      root.items.add(ComponentPage("страница"));
    }
    curPage = root.items.whereType<ComponentPage>().first;

    if (root.items.whereType<SourcePage>().isEmpty) {
      var sourcePage = SourcePage("страница данных");
      root.items.add(sourcePage);
      curItemOnPage[SourcePage] = sourcePage;
    } else {
      var sourcePage = root.items.whereType<SourcePage>().first;
      curItemOnPage[SourcePage] = sourcePage;
    }

    if (root.items.whereType<StylePage>().isEmpty) {
      var stylePage = StylePage("страница стилей");
      root.items.add(stylePage);
      curItemOnPage[StylePage] = stylePage;
    } else {
      var stylePage = root.items.whereType<StylePage>().first;
      curItemOnPage[StylePage] = stylePage;
    }

    //добавляем базовый стиль, если отсутствует в файле
    var stylePage = root.items.whereType<StylePage>().first;

    if (stylePage.items
        .whereType<StyleElement>()
        .where((element) => element['id'] == Uuid.nil)
        .isEmpty) {
      StyleElement basicElement = StyleElement("базовый стиль");
      basicElement.properties['id'] =
          Property("идентификатор", Uuid.nil, type: Uuid);
      stylePage.items.insert(0, basicElement);
      //curItemOnPage[StylePage] = basicElement;
      _setPageForItem(stylePage, basicElement);
    }
    //добавляем базовый стиль
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
              "id" => Property("идентификатор", Uuid.parse(value), type: Uuid),
              "color" =>
                Property("цвет", Color(int.tryParse(value) ?? 0), type: Color),
              "style" => Property(
                  "стиль",
                  Style(Uuid.tryParse(value['id']) ?? Uuid.nil,
                      value['name'] ?? "базовый стиль"),
                  type: Style),
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
        case "stylePage":
          item = StylePage("");
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
        case "hiddenField":
          item = FormHiddenField("");
        case "styleElement":
          item = StyleElement("");
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
        //curComponent = item;
        if (item is! ComponentGroup) {
          for (var curItem in item.items) {
            _setComponentForItem(item, curItem);
          }
        }
      }

      if (item is ComponentAndSourcePage) {
        for (var curItem in item.items) {
          _setPageForItem(item, curItem);
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
        Style => {
            'id': property.value.id.toString(),
            'name': property.value.name.toString()
          },
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
    if (item is ComponentPage) {
      var indexLastPage = root.items
          .lastIndexWhere((element) => element.runtimeType == ComponentPage);
      root.items.insert(++indexLastPage, item);
    } else if (item is LayoutComponentAndSource) {
      //_curItem.items.add(item);

      parent.items.add(item);

      //curComponent = item is ComponentGroup ? null : item;

      var page = getPageByItem(parent);

      _setPageForItem(page!, item);

      if (item is! ComponentGroup) {
        for (var subItem in item.items) {
          _setComponentForItem(item, subItem);
        }
      }
      //_setComponentForItem(item);
    } else {
      /*if (curComponent == null) {
        return;
      }

      var indexLastItem = _curItem.items
          .lastIndexWhere((element) => element.runtimeType == item.runtimeType);
      _curItem.items.insert(++indexLastItem, item);*/

      var component = getComponentByItem(parent);

      if (component == null) {
        return;
      }

      var indexLastItem = parent.items
          .lastIndexWhere((element) => element.runtimeType == item.runtimeType);
      parent.items.insert(++indexLastItem, item);

      switch (item.runtimeType) {
        case ComponentTableColumn:
          component.items
              .where((element) => element.runtimeType == ComponentTableRowGroup)
              .forEach((rowGroup) {
            for (var row in rowGroup.items) {
              var cell = ComponentTableCell("ячейка");
              row.items.add(cell);

              //_setComponentForItem(component, cell);
            }
          });

        case ComponentTableRowGroup:
          var row = ComponentTableRow("строка");
          item.items.add(row);
          //_setComponentForItem(component, row);

          component.items
              .where((element) => element.runtimeType == ComponentTableColumn)
              .forEach((rowGroup) {
            var cell = ComponentTableCell("ячейка");

            row.items.add(cell);

            //_setComponentForItem(component, cell);
          });
        case ComponentTableRow:
          component.items
              .where((element) => element.runtimeType == ComponentTableColumn)
              .forEach((rowGroup) {
            var cell = ComponentTableCell("ячейка");

            item.items.add(cell);

            //_setComponentForItem(component, cell);
          });

        default:
      }

      _setComponentForItem(component, item);
      var page = getPageByItem(parent);
      _setPageForItem(page!, item);
    }
  }

  deleteItem(Item item) {
    var component = getComponentByItem(item);

    var page = getPageByItem(item);

    if (item is ComponentAndSourcePage) {
      root.items.remove(item);
      curItem = root;
    } else if (item is LayoutComponentAndSource) {
      if (page!.items.contains(item)) {
        page.items.remove(item);
        _curItem = page;
      } else {
        var groups = page.items.whereType<ComponentGroup>();

        for (var group in groups) {
          if (group.items.contains(item)) {
            group.items.remove(item);
            _curItem = group;
            break;
          }
        }
      }

      //if (curPage.items.isEmpty) {
      //curComponent = null;
      //} else {
      //  curComponent = curPage.items.first as LayoutComponent;
      //}
    } else {
      if (component == null) {
        return;
      }

      switch (item.runtimeType) {
        case ComponentTableColumn:
          var indexOfColumn = component.items
              .where((element) => element.runtimeType == ComponentTableColumn)
              .toList()
              .indexOf(item);

          component.items.remove(item);
          component.items
              .where((element) => element.runtimeType == ComponentTableRowGroup)
              .forEach((rowGroup) {
            for (var row in rowGroup.items) {
              row.items.removeAt(indexOfColumn);
            }
          });

          curItem = component;

        case ComponentTableRowGroup:
          component.items.remove(item);
          curItem = component;
        case ComponentTableRow:
          ComponentTableRowGroup? foundGroup;
          component.items
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
          curItem = foundGroup!;

        case SourceTableColumn:
          component.items.remove(item);
          curItem = component;

        default:
      }
    }
  }

  _setPageForItem(ComponentAndSourcePage page, Item item) {
    _itemsOnPage[item] = page;

    for (var subItem in item.items) {
      _setPageForItem(page, subItem);
    }
  }

  _setComponentForItem(LayoutComponentAndSource? component, Item item) {
    if (component == null) {
      return;
    }
    //_itemsOnComponent[_curComponent!] = _curComponent!;
    _itemsOnComponent[item] = component;

    for (var curItem in item.items) {
      _setComponentForItem(component, curItem);
    }
  }
}
