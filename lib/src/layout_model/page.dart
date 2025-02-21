import 'item.dart';

class ComponentAndSourcePage extends Item {

  ComponentAndSourcePage(super.type, super.name, {super.mayBeParent = true});
}

class ComponentPage extends ComponentAndSourcePage {
  ComponentPage(name) : super("componentPage", name,mayBeParent : true);
}

class SourcePage extends ComponentAndSourcePage {
  SourcePage(name) : super("sourcePage", name,mayBeParent : true);
}

class StylePage extends ComponentAndSourcePage {
  StylePage(name) : super("stylePage", name, mayBeParent : true);
}

class ProcessPage extends ComponentAndSourcePage {
  ProcessPage(name, {this.viewport}) : super("processPage", name,mayBeParent : true);
  Map<String, dynamic>? viewport = {
    "offset": [0.0, 0.0],
    "zoom": 1.0
  };
}
