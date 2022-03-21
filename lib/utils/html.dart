import 'style.dart';

abstract class HtmlNode {
  StyleNode styleTree(StyleSheet sheet);
}

class HtmlText implements HtmlNode {
  final String text;

  const HtmlText(this.text);

  @override
  StyleNode styleTree(StyleSheet sheet) {
    return StyleNode(node: this, propertyMap: {}, children: []);
  }
}

class HtmlElement implements HtmlNode {
  final String tagName;
  final Map<String, String> attributeMap;
  final List<HtmlNode> children;

  const HtmlElement({
    required this.tagName,
    this.attributeMap = const {},
    this.children = const [],
  });

  String? get id => attributeMap['id'];

  Set<String> get classes => attributeMap['class']?.split(' ').toSet() ?? {};

  Set<Rule> matchingRules(StyleSheet style) {
    return style.rules.where((rule) => rule.matches(this)).toSet();
  }

  Map<String, dynamic> specifiedValues(StyleSheet style) {
    final Map<String, dynamic> values = {};

    for (final rule in style.rules) {
      for (final declaration in rule.declarations) {
        values[declaration.name] = declaration.value;
      }
    }

    return values;
  }

  @override
  StyleNode styleTree(StyleSheet style) {
    return StyleNode(
      node: this,
      propertyMap: specifiedValues(style),
      children: children.map((c) => styleTree(style)).toList(),
    );
  }
}

class Attribute {
  final String key;
  final String value;

  const Attribute(this.key, this.value);
}

class HtmlParser {
  final String _input;
  int _position = 0;

  static const escapeCharacters = {'amp': '&', 'nbsp': ' '};

  HtmlParser._(this._input);

  String _nextChar() {
    return _input[_position];
  }

  bool _startsWith(String str) {
    return _input.substring(_position).startsWith(str);
  }

  bool _endOfFile() {
    return _position >= _input.length;
  }

  String _consumeChar() {
    final nextChar = _input[_position];
    _position++;
    return nextChar;
  }

  String _consumeWhile<F extends bool Function(String)>(F test) {
    var result = '';
    while (!_endOfFile() && test(_nextChar())) {
      result += _consumeChar();
    }

    return result;
  }

  _consumeWhitespace() {
    _consumeWhile((c) => [' ', '\n', '\r', '\t'].contains(c));
  }

  String _parseTagName() {
    return _consumeWhile((c) =>
        (48 <= c.codeUnitAt(0) && c.codeUnitAt(0) <= 57) ||
        (65 <= c.codeUnitAt(0) && c.codeUnitAt(0) <= 90) ||
        (97 <= c.codeUnitAt(0) && c.codeUnitAt(0) <= 122));
  }

  HtmlText _parseText() {
    String text = _consumeWhile((c) => c != '<');
    for (final mapping in escapeCharacters.entries) {
      text = text.replaceAll('&${mapping.key};', mapping.value);
    }
    return HtmlText(text);
  }

  String _parseAttributeValue() {
    final openQuote = _consumeChar();
    assert(openQuote == '"' || openQuote == "'");
    final value = _consumeWhile((c) => c != openQuote);
    assert(_consumeChar() == openQuote);
    return value;
  }

  Attribute _parseAttribute() {
    final name = _parseTagName().toLowerCase();
    assert(_consumeChar() == '=');
    final value = _parseAttributeValue();
    return Attribute(name, value);
  }

  Map<String, String> _parseAttributes() {
    Map<String, String> attributes = {};
    while (true) {
      _consumeWhitespace();
      if (_nextChar() == '>') {
        break;
      }
      final attribute = _parseAttribute();
      attributes[attribute.key] = attribute.value;
    }

    return attributes;
  }

  HtmlElement _parseElement() {
    // open tag
    assert(_consumeChar() == '<');
    final tagName = _parseTagName().toLowerCase();
    final attributes = _parseAttributes();
    final isSelfClosingChar = _consumeChar();
    final isSelfClosingTag = isSelfClosingChar == '/';
    if (isSelfClosingTag) {
      assert(_consumeChar() == '>');
    } else {
      assert(isSelfClosingChar == '>');
    }

    // self-closing tags
    if (isSelfClosingTag ||
        tagName == 'br' ||
        tagName == 'img' ||
        tagName == 'hr') {
      return HtmlElement(tagName: tagName, attributeMap: attributes);
    }

    // contents
    final children = _parseNodes();

    // closing tag
    assert(_consumeChar() == '<');
    assert(_consumeChar() == '/');
    assert(_parseTagName() == tagName);
    assert(_consumeChar() == '>');

    return HtmlElement(
      tagName: tagName,
      attributeMap: attributes,
      children: children,
    );
  }

  HtmlNode _parseNode() {
    if (_nextChar() == '<') {
      return _parseElement();
    } else {
      return _parseText();
    }
  }

  List<HtmlNode> _parseNodes() {
    List<HtmlNode> nodes = [];
    while (true) {
      _consumeWhitespace();
      if (_endOfFile() || _startsWith('</')) {
        break;
      }
      nodes.add(_parseNode());
    }

    return nodes;
  }

  static HtmlNode parse(String input) {
    var nodes = HtmlParser._(input)._parseNodes();

    if (nodes.length == 1) {
      return nodes[0];
    } else {
      return HtmlElement(tagName: 'html', children: nodes);
    }
  }
}
