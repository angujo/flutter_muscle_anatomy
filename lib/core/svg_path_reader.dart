part of 'core.dart';

/// A utility class for reading and parsing path data from SVG files.
///
/// It provides mechanisms to retrieve SVG path 'd' attributes by ID,
/// with support for group elements and automatic caching.
class SvgPathReader {
  /// Internal cache to store instances of [SvgPathReader] per file path.
  static final Map<String, SvgPathReader> _instances = {};

  /// Path to the SVG file.
  final String _filePath;

  /// The parsed XML document of the SVG.
  XmlDocument? _document;

  /// Cached width of the SVG.
  double? _width;

  /// Cached height of the SVG.
  double? _height;

  /// Cache for individual path IDs: pathId -> path d string.
  final Map<String, String> _pathCache = {};

  /// Cache for group IDs: groupId -> list of path d strings.
  final Map<String, List<String>> _groupCache = {};

  /// Private constructor for [SvgPathReader].
  SvgPathReader._(this._filePath);

  /// Internal factory method to manage [SvgPathReader] instances.
  ///
  /// Ensures that only one instance of [SvgPathReader] exists for a specific [filePath].
  static SvgPathReader _fromFile(String filePath) {
    if (_instances.containsKey(filePath)) {
      return _instances[filePath]!;
    }
    final inst = SvgPathReader._(filePath);
    _instances[filePath] = inst;
    return inst;
  }

  /// Returns an [SvgPathReader] for the male body based on the specified [view].
  static SvgPathReader male(BodyView view) {
    return switch (view) {
      BodyView.front => maleFront(),
      BodyView.back => maleBack(),
      _ => throw UnimplementedError('Male View $view not implemented!'),
    };
  }

  /// Returns an [SvgPathReader] for the female body based on the specified [view].
  static SvgPathReader female(BodyView view) {
    return switch (view) {
      BodyView.front => femaleFront(),
      BodyView.back => femaleBack(),
      _ => throw UnimplementedError('Female View $view not implemented!'),
    };
  }

  /// Returns an [SvgPathReader] for the male front view.
  static SvgPathReader maleFront() => _fromFile('assets/male_front.svg');

  /// Returns an [SvgPathReader] for the female front view.
  static SvgPathReader femaleFront() => _fromFile('assets/female_front.svg');

  /// Returns an [SvgPathReader] for the male back view.
  static SvgPathReader maleBack() => _fromFile('assets/male_back.svg');

  /// Returns an [SvgPathReader] for the female back view.
  static SvgPathReader femaleBack() => _fromFile('assets/female_back.svg');

  /// The intrinsic width of the SVG defined in the 'width' attribute.
  double get width {
    _ensureLoaded();
    _loadDimensionsIfNeeded();
    return _width ?? 0.0;
  }

  /// The intrinsic height of the SVG defined in the 'height' attribute.
  double get height {
    _ensureLoaded();
    _loadDimensionsIfNeeded();
    return _height ?? 0.0;
  }

  /// Extracts and caches SVG dimensions from the root element.
  void _loadDimensionsIfNeeded() {
    if (_width != null || _height != null) return;

    final svg = _document!.rootElement;

    _width = _parseSvgLength(svg.getAttribute('width')) ?? 0;
    _height = _parseSvgLength(svg.getAttribute('height')) ?? 0;
  }

  /// Parses a numeric value from an SVG length string (e.g., "100", "100px").
  double? _parseSvgLength(String? value) {
    if (value == null) return null;

    // Handles values like "100", "100px", "100.5"
    final numeric = RegExp(r'[\d.]+').firstMatch(value)?.group(0);
    return numeric != null ? double.tryParse(numeric) : null;
  }

  /// Reads the file from disk and parses the XML if not already done.
  void _ensureLoaded() {
    if (_document == null) {
      final content = File(_filePath).readAsStringSync();
      _document = XmlDocument.parse(content);
    }
  }

  /// Returns a list of path 'd' attributes associated with the given [pathId].
  ///
  /// This method searches for a `<path>` or `<g>` element with the matching 'id' attribute.
  /// It automatically handles cases where an ID represents a pair of symmetric muscles
  /// by checking for 'left_' and 'right_' prefixes if the original ID is not found.
  List<String> getPathDs(String pathId) {
    _ensureLoaded();
    final id = pathId.toLowerCase();

    // Check caches first
    if (_pathCache.containsKey(id)) {
      return [_pathCache[id]!];
    }
    if (_groupCache.containsKey(id)) {
      return _groupCache[id]!;
    }
    if (!id.contains('outline') && !id.startsWith('left_') && !id.startsWith('right_')) {
      final paths = getPathDs('right_$id') + getPathDs('left_$id');
      if(paths.isNotEmpty) {
        _groupCache[id] = paths;
        return paths;
      }
    }

    final doc = _document!;

    // Try path
    final path = _findPathById(doc.rootElement, id);
    if (path != null) {
      final d = path.getAttribute('d') ?? '';
      _pathCache[id] = d;
      return [d];
    }

    // Try group
    final group = _findGroupById(doc.rootElement, id);
    if (group != null) {
      final ds = _collectPathsFromGroup(group);
      _groupCache[id] = ds;
      return ds;
    }

    return [];
  }

  /// Recursively finds a `<path>` element with the specified [id].
  XmlElement? _findPathById(XmlElement element, String id) {
    if (element.name.local == 'path' &&
        element.getAttribute('id')?.toLowerCase() == id) {
      return element;
    }
    for (var child in element.children.whereType<XmlElement>()) {
      final found = _findPathById(child, id);
      if (found != null) return found;
    }
    return null;
  }

  /// Recursively finds a `<g>` (group) element with the specified [id].
  XmlElement? _findGroupById(XmlElement element, String id) {
    if (element.name.local == 'g' &&
        element.getAttribute('id')?.toLowerCase() == id) {
      return element;
    }
    for (var child in element.children.whereType<XmlElement>()) {
      final found = _findGroupById(child, id);
      if (found != null) return found;
    }
    return null;
  }

  /// Traverses a group element and collects all 'd' attributes from its descendant `<path>` elements.
  List<String> _collectPathsFromGroup(XmlElement group) {
    final paths = <String>[];

    void collect(XmlElement element) {
      if (element.name.local == 'path') {
        final d = element.getAttribute('d');
        if (d != null) paths.add(d);
      } else if (element.name.local == 'g') {
        for (var child in element.children.whereType<XmlElement>()) {
          collect(child);
        }
      }
    }

    collect(group);
    return paths;
  }
}
