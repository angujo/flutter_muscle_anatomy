part of 'core.dart';

/// A class responsible for generating SVG file content by building an XML structure.
final class SvgFileWriter {
  final _builder = XmlBuilder();
  final Size _size;
  final List<SvgElement> _elements = [];
  XmlDocument? _document;

  /// Creates a new [SvgFileWriter] with the specified [size].
  SvgFileWriter(this._size);

  /// Adds a single [SvgElement] to be included in the SVG.
  void addElement(SvgElement element) {
    _elements.add(element);
  }

  /// Adds multiple [SvgElement]s to be included in the SVG.
  void addElements(Iterable<SvgElement> elements) {
    _elements.addAll(elements);
  }

  /// Builds the [XmlDocument] representing the SVG.
  ///
  /// This method constructs the root `<svg>` element, adds metadata,
  /// and iterates through all added elements to build the final document.
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

  /// Returns the SVG content as an XML string.
  ///
  /// Pretty printing is disabled for performance.
  @override
  String toString() {
    return build().toXmlString(pretty: false);
  }
}

/// Base class for SVG elements such as paths and groups.
class SvgElement {
  final String _tag;
  final String _id;
  final Map<String, String> _attributes = {};
  final Map<String, String> _styles = {};
  final List<SvgElement> _children = [];
  XmlElement? _element;

  /// Creates an [SvgElement] with the given [_tag] and [_id].
  SvgElement({required String tag, required String id}) : _tag = tag, _id = id;

  /// Adds a custom attribute to the element.
  void addAttribute(String key, String value) {
    _attributes[key] = value;
  }

  /// Adds multiple attributes to the element.
  void addAttributes(Map<String, String> attributes) {
    _attributes.addAll(attributes);
  }

  /// Adds multiple CSS-style attributes to the element.
  void addStyles(Map<String, String> styles) {
    _styles.addAll(styles);
  }

  /// Adds a single CSS-style attribute to the element.
  void addStyle(String key, String value) {
    _styles[key] = value;
  }

  /// Adds a child [SvgElement] to this element.
  void addChild(SvgElement child) {
    _children.add(child);
  }

  /// Adds multiple child [SvgElement]s to this element.
  void addChildren(Iterable<SvgElement> children) {
    _children.addAll(children);
  }

  /// Internal method to contribute this element to an [XmlBuilder].
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

  /// Builds and returns the [XmlElement] for this element.
  XmlElement build() {
    if (null != _element) {
      return _element!;
    }
    final Map<String, String> attrs = Map.from(_attributes);
    attrs['id'] = _id;
    if (_styles.isNotEmpty) attrs['style'] = _stylesToString();
    _element = XmlElement(
      XmlName.parts(_tag),
      [
        ..._attributes.entries.map(
          (e) => XmlAttribute(XmlName.parts(e.key), e.value),
        ),
      ],
      [..._children.map((e) => e.build())],
    );
    return _element!;
  }

  /// Converts the internal style map to a standard SVG 'style' attribute string.
  String _stylesToString() {
    if (_styles.isEmpty) return '';
    final buffer = StringBuffer();
    for (final entry in _styles.entries) {
      if (buffer.isNotEmpty) buffer.write(';');
      buffer.write(entry.key);
      buffer.write(':');
      buffer.write(entry.value);
    }
    return buffer.toString();
  }

  /// Returns the XML string representation of this element.
  @override
  String toString() {
    return build().toString();
  }
}

/// Represents an SVG group element (`<g>`).
class SvgGroup extends SvgElement {
  /// Creates an [SvgGroup] with the specified [id].
  SvgGroup({required super.id}) : super(tag: 'g');
}

/// Represents an SVG path element (`<path>`).
class SvgPath extends SvgElement {
  /// The path data string (the 'd' attribute).
  final String d;

  /// Creates an [SvgPath] with the specified [id] and path data [d].
  ///
  /// Initializes the path with default stroke and fill styles.
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

  /// Sets the stroke color, width, and opacity for the path.
  void stroke(Color color, {double? width, double? opacity}) {
    addStyle('stroke', color.toHex());
    if (width != null) addStyle('stroke-width', width.toString());
    if (opacity != null) addStyle('stroke-opacity', opacity.toString());
  }

  /// Sets the fill color and opacity for the path.
  void fill(Color color, {double? opacity}) {
    addStyle('fill', Colors.transparent == color ? 'none' : color.toHex());
    if (opacity != null) addStyle('fill-opacity', opacity.toString());
  }

  /// Overridden to prevent manual modification of the 'd' attribute.
  @override
  void addAttribute(String key, String value) {
    if (key == 'd') return;
    super.addAttribute(key, value);
  }

  /// Overridden to prevent manual modification of the 'd' attribute via a map.
  @override
  void addAttributes(Map<String, String> attributes) {
    final Map<String, String> attrs = Map.from(attributes);
    attrs.remove('d');
    super.addAttributes(attrs);
  }

  /// Paths cannot have children in this implementation.
  @override
  void addChild(SvgElement child) {
    return;
  }

  /// Paths cannot have children in this implementation.
  @override
  void addChildren(Iterable<SvgElement> children) {
    return;
  }
}
