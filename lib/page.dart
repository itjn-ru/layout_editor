import 'package:layout_editor/item.dart';

class ComponentAndSourcePage extends Item {
  ComponentAndSourcePage(type, name) : super(type, name);
}


class ComponentPage extends ComponentAndSourcePage {
  ComponentPage(name) : super("componentPage", name);
}

class SourcePage extends ComponentAndSourcePage {
  SourcePage(name) : super("sourcePage", name);
}

class PalettePage extends ComponentAndSourcePage {
  PalettePage(name) : super("palettePage", name);
}