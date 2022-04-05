import 'package:flutter/widgets.dart';

import 'html.dart';
import 'style.dart';

class Dimensions {
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Border border;

  const Dimensions(
      {this.padding = EdgeInsets.zero,
      this.margin = EdgeInsets.zero,
      this.border = const Border()});

  static const zero = Dimensions();
}

class LayoutBox {
  late final Dimensions dimensions;
  late final Display display;
  late final StyleNode? node;
  late final List<LayoutBox> children;

  String? get text {
    final htmlNode = node?.node;
    if (htmlNode is HtmlText) {
      return htmlNode.text;
    } else {
      return null;
    }
  }

  LayoutBox(
      {this.dimensions = Dimensions.zero,
      this.display = Display.inline,
      this.node,
      this.children = const []});

  LayoutBox.fromStyleNode(StyleNode styleNode) {
    display = styleNode.display();
    dimensions = Dimensions.zero;
    node = styleNode;

    children = [];
    for (final child in styleNode.children) {
      switch (child.display()) {
        case Display.block:
          children.add(LayoutBox.fromStyleNode(child));
          break;
        case Display.inline:
          _getInlineContainer().children.add(LayoutBox.fromStyleNode(child));
          break;
        case Display.none:
          break;
      }
    }
  }

  static LayoutBox fromHtmlString(String html) {
    return LayoutBox.fromStyleNode(HtmlParser.parse(html).styleTree(StyleSheet([
      Rule(
        selector: TagSelector('p'),
        declarations: [Declaration(name: 'display', value: 'block')],
      )
    ])));
  }

  LayoutBox _getInlineContainer() {
    switch (display) {
      case Display.inline:
      case Display.none:
        return this;
      case Display.block:
        if (children.isEmpty) {
          children.add(LayoutBox(children: []));
        }

        return children.last;
    }
  }
}
