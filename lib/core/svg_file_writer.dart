part of 'core.dart';

final class SvgFileWriter {
  final _builder = XmlBuilder();
  final Size _size;
  final List<SvgElement> _elements = [];
  XmlDocument? _document;

  SvgFileWriter(this._size);

  void addElement(SvgElement element) {
    _elements.add(element);
  }

  void addElements(Iterable<SvgElement> elements) {
    _elements.addAll(elements);
  }

  XmlDocument build() {
    if (null != _document) return _document!;
    _builder.processing(
      'xml',
      'version="1.0" encoding="UTF-8" standalone="no"',
    );
    _builder.element(
      'svg',
      attributes: {
        'version': '1.1',
        'id': 'svg1',
        'width': '${_size.width}',
        'height': '${_size.height}',
        'viewBox': '0 0 ${_size.width} ${_size.height}',
        'xmlns': 'http://www.w3.org/2000/svg',
        'xmlns:svg': 'http://www.w3.org/2000/svg',
      },
      nest: () {
        _builder.element('defs', attributes: {'id': 'defs1'});
        for (final element in _elements) {
          element._forBuilder(_builder);
        }
      },
    );
    _document = _builder.buildDocument();
    return _document!;
  }

  @override
  String toString() {
    return build().toXmlString(pretty: true);
  }
}

class SvgElement {
  final String _tag;
  final String _id;
  final Map<String, String> _attributes = {};
  final Map<String, String> _styles = {};
  final List<SvgElement> _children = [];
  XmlElement? _element;

  SvgElement({required String tag, required String id}) : _tag = tag, _id = id;

  void addAttribute(String key, String value) {
    _attributes[key] = value;
  }

  void addAttributes(Map<String, String> attributes) {
    _attributes.addAll(attributes);
  }

  void addStyles(Map<String, String> styles) {
    _styles.addAll(styles);
  }

  void addStyle(String key, String value) {
    _styles[key] = value;
  }

  void addChild(SvgElement child) {
    _children.add(child);
  }

  void addChildren(Iterable<SvgElement> children) {
    _children.addAll(children);
  }

  void _forBuilder(XmlBuilder builder) {
    final Map<String, String> attrs = Map.from(_attributes);
    attrs['id'] = _id;
    if (_styles.isNotEmpty) attrs['style'] = _stylesToString();
    builder.element(
      _tag,
      attributes: attrs,
      nest: _children.isEmpty
          ? null
          : () {
              for (final child in _children) {
                child._forBuilder(builder);
              }
            },
    );
  }

  XmlElement build() {
    if (null != _element) {
      return _element!;
    }
    final Map<String, String> attrs = Map.from(_attributes);
    attrs['id'] = _id;
    if (_styles.isNotEmpty) attrs['style'] = _stylesToString();
    _element = XmlElement(
      XmlName(_tag),
      [
        ..._attributes.entries.map(
          (e) => XmlAttribute(XmlName(e.key), e.value),
        ),
      ],
      [..._children.map((e) => e.build())],
    );
    return _element!;
  }

  String _stylesToString() {
    return _styles.entries.map((st) => '${st.key}:${st.value}').join(';');
  }

  @override
  String toString() {
    return build().toString();
  }
}

class SvgGroup extends SvgElement {
  SvgGroup({required super.id}) : super(tag: 'g');
}

class SvgPath extends SvgElement {
  final String d;

  SvgPath({required super.id, required this.d}) : super(tag: 'path') {
    super.addAttribute('d', d);
    addStyles({
      'display': 'inline',
      'fill': 'none',
      'stroke': '#000000',
      'stroke-width': '0.2',
      'stroke-linecap': 'round',
      'stroke-linejoin': 'round',
      'stroke-dasharray': 'none',
      'stroke-dashoffset': '0',
      'stroke-opacity': '1',
      'paint-order': 'stroke fill markers',
    });
  }

  void stroke(Color color, {double? width, double? opacity}) {
    addStyle('stroke', color.toHex());
    if (width != null) addStyle('stroke-width', width.toString());
    if (opacity != null) addStyle('stroke-opacity', opacity.toString());
  }

  void fill(Color color, {double? opacity}) {
    addStyle('fill', Colors.transparent == color ? 'none' : color.toHex());
    if (opacity != null) addStyle('fill-opacity', opacity.toString());
  }

  @override
  void addAttribute(String key, String value) {
    if (key == 'd') return;
    super.addAttribute(key, value);
  }

  @override
  void addAttributes(Map<String, String> attributes) {
    final Map<String, String> attrs = Map.from(attributes);
    attrs.remove('d');
    super.addAttributes(attrs);
  }

  @override
  void addChild(SvgElement child) {
    return;
  }

  @override
  void addChildren(Iterable<SvgElement> children) {
    return;
  }
}
