import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:layout_editor/component.dart';
import 'package:layout_editor/components_and_sources.dart';
import 'package:layout_editor/items.dart';
import 'package:layout_editor/layout_model.dart';
import 'package:layout_editor/page.dart';
import 'package:layout_editor/properties.dart';
import 'package:layout_editor/root.dart';
import 'package:layout_editor/component_table.dart';
import 'package:provider/provider.dart';

import 'download_service.dart';
import 'menu.dart';
import 'file.dart';
import 'item.dart';

void main() {
  runApp(
    Provider(
      create: (context) => LayoutModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  Root _root = Root("root");

  final targetWidgetKey = GlobalKey();

  late Item _curPage;

  Item? _curItem;

  LayoutComponent? _curComponent = null;

  //List<Item> _items = <Item>[];
  //List<Item> _sources = <Item>[];

  Map<Item, Item> _itemsOnPage = {};
  Map<Item, LayoutComponent> _itemsOnComponent = {};

  void _incrementCounter() {
    return;

    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;

      var component = ComponentTable("table");
      _curComponent = component;
      _curPage.items.add(component);

      //_setPageForItem(component);
      //_setComponentForItem(component);
    });
  }

  @override
  void initState() {
    super.initState();

    //_curPage = ComponentPage("components");
    //_setPageForItem(_curPage);

    //_root.items.add(_curPage);
    //_root.items.add(SourcePage("sources"));
    //_items.add(_curPage);

    //_curItem = _root;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    //final targetWidgetKey = GlobalKey();

    //final key = GlobalKey<State<BottomNavigationBar>>();

    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),

        actions: [
          Consumer<LayoutModel>(
            builder: (context, value, child) {
              return ElevatedButton(
                  onPressed: () async {
                    var map = value.toMap();

                    await saveFile(
                        body: saveMap(map), filename: value.root['name']);
                  },
                  child: Text("Сохранить"));
            },
          ),
          Consumer<LayoutModel>(
            builder: (context, value, child) {
              return ElevatedButton(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles();

                    if (result == null) {
                      return;
                    }

                    PlatformFile file = result.files.first;

                    var map = readMap(utf8.decode(file.bytes as List<int>));
                    value.fromMap(map);

                    //value.root = read(utf8.decode(file.bytes as List<int>));

                    setState(() {});
                  },
                  child: Text("Открыть"));
            },
          ),
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Row(
          children: [
            SizedBox(
              width: 360,
              child: ListView(children: [
                Consumer<LayoutModel>(
                  builder: (context, value, child) => Items(
                    /*value.root,*/ onItemChanged: (item) {
                      setState(() {});
                    },
                  ),
                ),

                /*Items(_root, onItemChanged: (item) {
                setState(() {
                  _curItem = item;
                });
              }),*/
              ]),
            ),
            Divider(),
            Expanded(
              child: Column(
                children: [
                  Consumer<LayoutModel>(
                    builder: (context, value, child) {
                      return ComponentsAndSources(value.curPage.items);
                    },
                  ),
                ], // [Components(_itemsOnPage[_curItem]?.items ?? [])],
              ),
            ),
            Divider(),
            SizedBox(
              width: 360,
              child: ListView(
                children: [
                  Consumer<LayoutModel>(
                    builder: (context, value, child) =>
                        Properties(value.curItem.properties ?? {}),
                  ),
                ],
                //_curItem == null ? [] : [Properties(_curItem!.properties)],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FAB(
        key: targetWidgetKey,
        onChanged: (p0) {
          setState(() {});
        },
      ), /*FloatingActionButton(

      ), */ // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  /*RelativeRect buttonMenuPosition(RenderBox renderBox, RenderBox overlay) {
    //RenderBox renderBox = keyContext.findRenderObject() as RenderBox;
    //RenderBox overlay = Overlay.of(keyContext).context.findRenderObject() as RenderBox;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        renderBox.localToGlobal(renderBox.size.bottomLeft(Offset.zero),
            ancestor: overlay),
        renderBox.localToGlobal(renderBox.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    return position;
  }

  _setPageForItem(Item item) {
    _itemsOnPage[item] = _curPage;

    for (var curItem in item.items) {
      _setPageForItem(curItem);
    }
  }

  _setComponentForItem(Item item) {
    if (_curComponent == null) {
      return;
    }
    //_itemsOnComponent[_curComponent!] = _curComponent!;
    _itemsOnComponent[item] = _curComponent!;

    for (var curItem in item.items) {
      _setComponentForItem(curItem);
    }
  }*/
}
