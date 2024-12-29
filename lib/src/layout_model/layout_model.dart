import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'component_group.dart';
import 'component_table.dart';
import 'component_text.dart';
import 'form_checkbox.dart';
import 'form_image.dart';
import 'form_slider_button.dart';
import 'item.dart';
import 'page.dart';
import 'process_element.dart';
import 'property.dart';
import 'root.dart';
import 'source_table.dart';
import 'source_variable.dart';
import 'style.dart';
import 'style_element.dart';
import 'package:uuid/uuid.dart';

import 'component_and_source.dart';
import 'form_hidden_field.dart';
import 'form_radio.dart';
import 'form_text_field.dart';

class LayoutModel extends ChangeNotifier {
  late Root root;
  late ComponentAndSourcePage curPage;

  late Item _curItem;
  Item? _curComponentItem;
  Item? _curSourceItem;
  late Item _curStyleItem;

  late Type curPageType;

  Item get curItem {
    return curItemOnPage[curPageType]!;
  }

  set curItem(Item value) {
    _curItem = value;

    curItemOnPage[curPageType] = value;

    notifyListeners();
  }

  Item get curComponentItem {
    return _curComponentItem??ComponentPage('страница');
  }

  set curComponentItem(Item value) {
    _curComponentItem = value;
    notifyListeners();
  }
  Item get curSourceItem {
    return _curSourceItem??SourcePage('страница данных');
  }

  set curSourceItem(Item value) {
    _curSourceItem = value;
    notifyListeners();
  }

  List<Style> get styles {
    final styleList = <Style>[];

    final stylePage = root.items.whereType<StylePage>().first;

    final list = stylePage.items.whereType<StyleElement>();

    for (final style in list) {
      styleList.add(Style(style['id'], style['name']));
    }
    return styleList;
  }

  StyleElement? getStyleElementById(UuidValue id) {
    final stylePage = root.items.whereType<StylePage>().first;

    final list = stylePage.items.whereType<StyleElement>();

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
    root = Root('макет');
    curPage = ComponentPage('страница');
    curPageType = ComponentPage;
    //curItem = root;

    curItemOnPage[ComponentPage] = root;

    root.items.add(curPage);

    final sourcePage = SourcePage('страница данных');
    root.items.add(sourcePage);
    curItemOnPage[SourcePage] = sourcePage;

    final stylePage = StylePage('страница стилей');
    root.items.add(stylePage);
    curItemOnPage[StylePage] = stylePage;

    final processPage = ProcessPage('процессы');
    root.items.add(processPage);
    curItemOnPage[ProcessPage] = processPage;

    final StyleElement basicElement = StyleElement('базовый стиль');
    basicElement.properties['id'] =
        Property('идентификатор', UuidValue.nil, type: Uuid);
    stylePage.items.add(basicElement);
    //curItemOnPage[StylePage] = basicElement;
    _setPageForItem(stylePage, basicElement);
  }

  Future<void> fromMap(Map map) async {
    root = Root(map['properties']['name']);
    root
      ..properties = _propertiesFromMap(map['properties'])
      ..items = _itemsFromMap(root, map['items']);
    curItem = root;
    curItemOnPage[ComponentPage] = root;

    if (root.items.whereType<ComponentPage>().isEmpty) {
      root.items.add(ComponentPage('страница'));
    }
    curPage = root.items.whereType<ComponentPage>().first;

    if (root.items.whereType<SourcePage>().isEmpty) {
      final sourcePage = SourcePage('страница данных');
      root.items.add(sourcePage);
      curItemOnPage[SourcePage] = sourcePage;
    } else {
      final sourcePage = root.items.whereType<SourcePage>().first;
      curItemOnPage[SourcePage] = sourcePage;
    }

    if (root.items.whereType<StylePage>().isEmpty) {
      final stylePage = StylePage('страница стилей');
      root.items.add(stylePage);
      curItemOnPage[StylePage] = stylePage;
    } else {
      final stylePage = root.items.whereType<StylePage>().first;
      curItemOnPage[StylePage] = stylePage;
    }

    if (root.items.whereType<ProcessPage>().isEmpty) {
      final processPage = ProcessPage('процессы');
      root.items.add(processPage);
      curItemOnPage[ProcessPage] = processPage;
    } else {
      final processPage = root.items.whereType<ProcessPage>().first;
      curItemOnPage[ProcessPage] = processPage;
    }

    //добавляем базовый стиль, если отсутствует в файле
    final stylePage = root.items.whereType<StylePage>().first;

    if (stylePage.items
        .whereType<StyleElement>()
        .where((element) => element['id'] == UuidValue.nil)
        .isEmpty) {
      final StyleElement basicElement = StyleElement('базовый стиль');
      basicElement.properties['id'] =
          Property('идентификатор', UuidValue.nil, type: Uuid);
      stylePage.items.insert(0, basicElement);
      //curItemOnPage[StylePage] = basicElement;
      _setPageForItem(stylePage, basicElement);
    }
    //добавляем базовый стиль



    notifyListeners();
  }

  Map<String, Property> _propertiesFromMap(Map map) {
    final Map<String, Property> properties = map.map(
      (key, value) {
        return MapEntry(
            key,
            switch (key) {
            'statusId' =>Property('Status Id',value, type: String),
            'title' =>Property('title',value, type: String),
            'creatorTitle' =>Property('Creator Title',value, type: String),
              'Uint8List' =>
                // Property('картинка', Uint8List.fromList(value.codeUnits), type: Uint8List ),
                Property('картинка', base64.decode(value), type: Uint8List),
              'horizontalAlignment' => Property('горизонтальное выравнивание',
                  double.tryParse(value.toString()),
                  type: double),
              'verticalAlignment' => Property('вертикальное выравнивание',
                  double.tryParse(value.toString()),
                  type: double),
              'stylefontSize' => Property(
                  'размер шрифта', double.tryParse(value.toString() ?? '9'),
                  type: double),
              'isItalic' =>
                Property('Курсив', value == 'true' ? true : false, type: bool),
              'topBorder' => Property(
                  'Верхняя граница',
                  value.runtimeType == CustomBorderStyle
                      ? value
                      : CustomBorderStyle.fromMap(value),
                  type: CustomBorderStyle),
              'leftBorder' => Property(
                  'Левая граница',
                  value.runtimeType == CustomBorderStyle
                      ? value
                      : CustomBorderStyle.fromMap(value),
                  type: CustomBorderStyle),
              'rightBorder' => Property(
                  'Правая граница',
                  value.runtimeType == CustomBorderStyle
                      ? value
                      : CustomBorderStyle.fromMap(value),
                  type: CustomBorderStyle),
              'bottomBorder' => Property(
                  'Нижняя граница',
                  value.runtimeType == CustomBorderStyle
                      ? value
                      : CustomBorderStyle.fromMap(value),
                  type: CustomBorderStyle),
              'colspan' => Property(
                  'объединение строк', int.tryParse(value) ?? 0,
                  type: int),
              'rowspan' => Property(
                  'объединение колонок', int.tryParse(value) ?? 0,
                  type: int),
              'width' =>
                Property('ширина', double.tryParse(value), type: double),
              'height' =>
                Property('высота', double.tryParse(value), type: double),
              'fontWeight' => Property("насыщенность шрифта",
                  FontWeight.values[((int.tryParse(value) ?? 400) ~/ 100) - 1],
                  type: FontWeight),
/*
              'rowMergeStart' =>
                  Property('начало объединения строк', int.tryParse(value)??-1, type: int),
              'rowMergeSpan' =>
                  Property('кол-во объединения строк', int.tryParse(value)??-1, type: int),
              'columnMergestart' =>
                  Property('начало объединения колонок', int.tryParse(value)??-1, type: int),
              'columnMergeSpan' =>
                  Property('кол-во объединения колонок', int.tryParse(value)??-1, type: int),
*/
              'position' => Property(
                  'положение',
                  Offset(double.tryParse(value['left']) ?? 0,
                      double.tryParse(value['top']) ?? 0),
                  type: Offset),
              'size' => Property(
                  'размер',
                  Size(double.tryParse(value['width']) ?? 0,
                      double.tryParse(value['height']) ?? 0),
                  type: Size),
              'id' => Property('идентификатор', UuidValue.fromString(value),
                  type: UuidValue),
              'color' => Property(
                  'цвет', Color(int.tryParse(value, radix: 16) ?? 0),
                  type: Color),
              'style' => Property(
                  'стиль',
                  Style(UuidValue.fromString(value['id']) ?? UuidValue.nil,
                      value['name'] ?? 'базовый стиль'),
                  type: Style),
              'textStyle' => Property(
                  'стиль текста',
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
                  'выравнивание',
                  Alignment(double.tryParse(value['x']) ?? 0,
                      double.tryParse(value['y']) ?? 0),
                  type: Alignment),
              _ => Property(key, value)
            });
      },
    );
    notifyListeners();
    return properties;
  }

  List<Item> _itemsFromMap(Item parent, List list) {
    final List<Item> items = [];

    for (final element in list) {
      Item item = Item('item', 'item');
      switch (element['type']) {
        case 'componentPage':
          item = ComponentPage('');
        case 'sourcePage':
          item = SourcePage('');
        case 'stylePage':
          item = StylePage('');
        case 'processPage':
          item = ProcessPage('');
        case 'group':
          item = ComponentGroup('');
        case 'table':
          if (parent is ComponentPage) {
            item = ComponentTable('');
          } else if (parent is SourcePage) {
            item = SourceTable('');
          } else if (parent is ComponentGroup) {
            item = ComponentTable('');
          }
        case 'column':
          if (parent is ComponentTable) {
            item = ComponentTableColumn('');
          } else if (parent is SourceTable) {
            item = SourceTableColumn('');
          }
        case 'rowGroup':
          item = ComponentTableRowGroup('');
        case 'row':
          item = ComponentTableRow('');
        case 'cell':
          item = ComponentTableCell('','');
        case 'text':
          item = ComponentText('');
        case 'variable':
          item = SourceVariable('');
        case 'textField':
          item = FormTextField('');
        case 'radio':
          item = FormRadio('');
        case 'image':
          item = FormImage('');
        case "sliderButton":
          item = FormSliderButton('');
        case 'checkbox':
          item = FormCheckbox('');
        case 'hiddenField':
          item = FormHiddenField('');
        case 'styleElement':
          item = StyleElement('');
        case 'processElement':
          item = ProcessElement('');
      }

      final itemProperties = _propertiesFromMap(element['properties']);

      item.properties.forEach((key, value) {
        if (itemProperties.containsKey(key)) {
          if (key == 'fontSize') {
            item.properties[key]!.value =
                double.tryParse(itemProperties[key]?.value) ?? '11';
          }
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
          for (final curItem in item.items) {
            _setComponentForItem(item, curItem);
          }
        }
      }

      if (item is ComponentAndSourcePage) {
        for (final curItem in item.items) {
          _setPageForItem(item, curItem);
        }
      }

      items.add(item);
    }

    return items;
  }

  Map toMap() {
    final Map map = {};

    map['layout'] = {
      'properties': _propertiesToMap(root),
      'items': _itemsToMap(root)
    };

    return map['layout'];
  }

  Map _propertiesToMap(Item item) {
    final map = {};

    item.properties.forEach((key, property) {
      map[key] = switch (property.type) {
        //Uint8List=>String.fromCharCodes(property.value as List<int>),
        Uint8List => base64.encode(property.value),
        CustomBorderStyle => property.value.toMap(),
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
        FontWeight => property.value.value.toString(),
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

  List _itemsToMap(Item item) {
    final list = [];

    for (item in item.items) {
      list.add({
        'type': item.type,
        'properties': _propertiesToMap(item),
        'items': _itemsToMap(item)
      });
    }

    return list;
  }

  void addItem(Item parent, Item item) {
    if (item is ComponentPage) {
      var indexLastPage = root.items
          .lastIndexWhere((element) => element.runtimeType == ComponentPage);
      root.items.insert(++indexLastPage, item);
    } else if (item is LayoutComponentAndSource) {
      //_curItem.items.add(item);

      parent.items.add(item);

      //curComponent = item is ComponentGroup ? null : item;

      final page = getPageByItem(parent);

      _setPageForItem(page!, item);

      if (item is! ComponentGroup) {
        for (final subItem in item.items) {
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

      final component = getComponentByItem(parent);

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
            for (final row in rowGroup.items) {
              final cell = ComponentTableCell('ячейка','');
              row.items.add(cell);

              //_setComponentForItem(component, cell);
            }
          });

        case ComponentTableRowGroup:
          final row = ComponentTableRow('строка');
          item.items.add(row);
          //_setComponentForItem(component, row);

          component.items
              .where((element) => element.runtimeType == ComponentTableColumn)
              .forEach((rowGroup) {
            final cell = ComponentTableCell('ячейка','');

            row.items.add(cell);
          });
        case ComponentTableRow:
          component.items
              .where((element) => element.runtimeType == ComponentTableColumn)
              .forEach((rowGroup) {
            final cell = ComponentTableCell('ячейка','');

            item.items.add(cell);
          });

        default:
      }

      _setComponentForItem(component, item);
      final page = getPageByItem(parent);
      _setPageForItem(page!, item);
    }
  }

  void deleteItem(Item item) {
    final component = getComponentByItem(item);

    final page = getPageByItem(item);

    if (item is ComponentAndSourcePage) {
      root.items.remove(item);
      curItem = root;
    } else if (item is LayoutComponentAndSource) {
      if (page!.items.contains(item)) {
        page.items.remove(item);
        _curItem = page;
      } else {
        final groups = page.items.whereType<ComponentGroup>();

        for (final group in groups) {
          if (group.items.contains(item)) {
            group.items.remove(item);
            _curItem = group;
            break;
          }
        }
      }
    } else {
      if (component == null) {
        return;
      }

      switch (item.runtimeType) {
        case ComponentTableColumn:
          final indexOfColumn = component.items
              .where((element) => element.runtimeType == ComponentTableColumn)
              .toList()
              .indexOf(item);

          component.items.remove(item);
          component.items
              .where((element) => element.runtimeType == ComponentTableRowGroup)
              .forEach((rowGroup) {
            for (final row in rowGroup.items) {
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
    notifyListeners();
  }

  _setPageForItem(ComponentAndSourcePage page, Item item) {
    _itemsOnPage[item] = page;

    for (final subItem in item.items) {
      _setPageForItem(page, subItem);
    }
    notifyListeners();
  }

  void _setComponentForItem(LayoutComponentAndSource? component, Item item) {
    if (component == null) {
      return;
    }
    //_itemsOnComponent[_curComponent!] = _curComponent!;
    _itemsOnComponent[item] = component;

    for (final curItem in item.items) {
      _setComponentForItem(component, curItem);
    }
    notifyListeners();
  }
}
