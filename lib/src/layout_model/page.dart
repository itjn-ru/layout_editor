import 'item.dart';

class ComponentAndSourcePage extends Item {
  ComponentAndSourcePage(super.type, super.name);
}

class ComponentPage extends ComponentAndSourcePage {
  ComponentPage(name) : super("componentPage", name);
}

class SourcePage extends ComponentAndSourcePage {
  SourcePage(name) : super("sourcePage", name);
}

class StylePage extends ComponentAndSourcePage {
  StylePage(name) : super("stylePage", name);
}

class ProcessPage extends ComponentAndSourcePage {
  ProcessPage(name) : super("processPage", name);
}