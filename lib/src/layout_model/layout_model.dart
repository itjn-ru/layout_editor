import 'component.dart';
import 'component_group.dart';
import 'component_table.dart';
import 'constants.dart';
import 'from_map_to_map_mixin.dart';
import 'item.dart';
import 'page.dart';
import 'process_group.dart';
import 'property.dart';
import 'root.dart';
import 'screen_size_enum.dart';
import 'source_table.dart';
import 'style.dart';
import 'style_element.dart';
import 'component_and_source.dart';

class LayoutModel with FromMapToMap {
  late Root root;
  late ComponentAndSourcePage curPage;

  late Item _curItem;
  Item? _curComponentItem;
  Item? _curSourceItem;
  late Item _curStyleItem;
  final List<ScreenSizeEnum> screenSizes;


 ScreenSizeEnum currentScreenSize=ScreenSizeEnum.mobile;

  late Type curPageType;

  Item get curItem {
    return curItemOnPage[curPageType]!;
  }

  set curItem(Item value) {
    _curItem = value;

    curItemOnPage[curPageType] = value;
  }

  Item get curComponentItem {
    return _curComponentItem ?? ComponentPage('страница');
  }

  set curComponentItem(Item value) {
    _curComponentItem = value;
  }

  Item get curSourceItem {
    return _curSourceItem ?? SourcePage('страница данных');
  }

  set curSourceItem(Item value) {
    _curSourceItem = value;
  }

  ProcessPage get processes {
    return root.items.whereType<ProcessPage>().first;
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

  StyleElement? getStyleElementById(String id) {
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

  ComponentAndSourcePage getPageByItem(Item item) {
    if (item is Root) {
      return item.items.whereType<ComponentPage>().first;
    }

    if (item is ComponentAndSourcePage) {
      return item;
    }

    return _itemsOnPage[item]!;
  }

  LayoutModel({required this.screenSizes}){init();}

  void init() {
    root = Root('макет');
  //   for(var screenSize in screenSizes){
  // var component =ScreenSizePage('ScreenSizeEnum',screenSize);
  //       root.items.add(component);
  //   }
    // curPage = ComponentPage('страница');
    // curPageType = ComponentPage;
  

    //curItemOnPage[ComponentPage] = root;

   // root.items.add(curPage);
    for(var screenSize in screenSizes){
   var curPage =ComponentPage('страница',screenSize);
   curPageType = ComponentPage;
   curItemOnPage[ComponentPage] = root;
         root.items.add(curPage);
     }
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
        Property('идентификатор', UuidNil, type: String);
    stylePage.items.add(basicElement);
    //curItemOnPage[StylePage] = basicElement;
    _setPageForItem(stylePage, basicElement);
  }

  void fromMap(Map map) {
    root = Root(map['properties']['name']);
    root
      ..properties = propertiesFromMap(map['properties'])
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
        .where((element) => element['id'] == UuidNil)
        .isEmpty) {
      final StyleElement basicElement = StyleElement('базовый стиль');
      basicElement.properties['id'] =
          Property('идентификатор', UuidNil, type: String);
      stylePage.items.insert(0, basicElement);
      //curItemOnPage[StylePage] = basicElement;
      _setPageForItem(stylePage, basicElement);
    }
    //добавляем базовый стиль
  }

  List<Item> _itemsFromMap(Item parent, List list) {
    final List<Item> items = [];

    for (final element in list) {
      Item item = switchItem(element, parent);

      final itemProperties = propertiesFromMap(element['properties']);

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
      'properties': propertiesToMap(root),
      'items': itemsToMap(root)
    };

    return map['layout'];
  }

  void addItem(Item parent, Item item, {int? index}) {
    if (item is ComponentPage) {
      var indexLastPage = root.items
          .lastIndexWhere((element) => element.runtimeType == ComponentPage);
      root.items.insert(index ?? ++indexLastPage, item);
    } else if (item is LayoutComponentAndSource) {
      //_curItem.items.add(item);

      parent.items.insert(index ?? parent.items.length, item);

      //curComponent = item is ComponentGroup ? null : item;

      final page = getPageByItem(parent);

      _setPageForItem(page, item);

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
      parent.items.insert(index ?? ++indexLastItem, item);

      switch (item.runtimeType) {
        case const (ComponentTableColumn):
          component.items
              .where((element) => element.runtimeType == ComponentTableRowGroup)
              .forEach((rowGroup) {
            for (final row in rowGroup.items) {
              final cell = ComponentTableCell('ячейка');
              row.items.add(cell);

              //_setComponentForItem(component, cell);
            }
          });

        case const (ComponentTableRowGroup):
          final row = ComponentTableRow('строка');
          item.items.add(row);
          //_setComponentForItem(component, row);

          component.items
              .where((element) => element.runtimeType == ComponentTableColumn)
              .forEach((rowGroup) {
            final cell = ComponentTableCell('ячейка');

            row.items.add(cell);
          });
        case const (ComponentTableRow):
          component.items
              .where((element) => element.runtimeType == ComponentTableColumn)
              .forEach((rowGroup) {
            final cell = ComponentTableCell('ячейка');

            item.items.add(cell);
          });

        default:
      }

      _setComponentForItem(component, item);
      final page = getPageByItem(parent);
      _setPageForItem(page, item);
    }
  }

  void deleteCurrentItem() {
    deleteItem(curItem);
  }

  void deleteItem(Item item) {
    final component = getComponentByItem(item);

    final page = getPageByItem(item);

    if (item is ComponentAndSourcePage) {
      root.items.remove(item);
      curItem = root;
    } else if (item is LayoutComponentAndSource) {
      if (page.items.contains(item)) {
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
        final processGroups = page.items.whereType<ProcessGroup>();
        for (final group in processGroups) {
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
        case const (ComponentTableColumn):
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

        case const (ComponentTableRowGroup):
          component.items.remove(item);
          curItem = component;
        case const (ComponentTableRow):
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

        case const (SourceTableColumn):
          component.items.remove(item);
          curItem = component;

        default:
          component.items.remove(item);
          curItem = component;
      }
    }
  }

  _setPageForItem(ComponentAndSourcePage page, Item item) {
    _itemsOnPage[item] = page;

    for (final subItem in item.items) {
      _setPageForItem(page, subItem);
    }
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
  }

  Item? findParent(Item parent, Item item, Item pasteItem) {
    if (parent.items.isEmpty) return null;
    if (parent.items.contains(item)) {
      final index = parent.items.indexOf(item);
      addItem(parent, pasteItem, index: index);
      return parent;
    }
    for (var element in parent.items) {
      if (element.items.contains(item)) {
        final index = element.items.indexOf(item);
        addItem(element, pasteItem, index: index);
        return element;
      } else {
        var newParent = findParent(element, item, pasteItem);
        if (newParent != null) return newParent;
      }
    }
    return null;
  }
}
