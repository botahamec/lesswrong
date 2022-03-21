import 'html.dart';

class StyleSheet {
  final List<Rule> rules;

  StyleSheet(this.rules);
}

class Rule {
  final Selector selector;
  final List<Declaration> declarations;

  Rule({required this.selector, this.declarations = const []});

  bool matches(HtmlElement element) {
    return selector.matches(element);
  }
}

abstract class Selector {
  bool matches(HtmlElement element);
}

class TagSelector extends Selector {
  final String tagName;

  TagSelector(this.tagName);

  @override
  bool matches(HtmlElement element) {
    return element.tagName == tagName;
  }
}

class ClassSelector extends Selector {
  final Set<String> classes;

  ClassSelector(this.classes);

  @override
  bool matches(HtmlElement element) {
    return element.classes.any((c) => classes.contains(c));
  }
}

class Declaration {
  final String name;
  final dynamic value; // TODO make a Value type

  Declaration({required this.name, required this.value});
}

class StyleNode {
  final HtmlNode node;
  final Map<String, dynamic> propertyMap;
  final List<StyleNode> children;

  StyleNode({
    required this.node,
    this.propertyMap = const {},
    this.children = const [],
  });
}
