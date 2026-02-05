part of 'core.dart';

class SvgPathReader {
  static final Map<String, SvgPathReader> _instances = {};

  final String _filePath;
  XmlDocument? _document;
  double? _width;
  double? _height;

  // Cache for path IDs: pathId -> path d
  final Map<String, String> _pathCache = {};

  // Cache for group IDs: groupId -> list of path ds
  final Map<String, List<String>> _groupCache = {};

  SvgPathReader._(this._filePath);

  /// Factory method
  static SvgPathReader _fromFile(String filePath) {
    if (_instances.containsKey(filePath)) {
      return _instances[filePath]!;
    }
    final inst = SvgPathReader._(filePath);
    _instances[filePath] = inst;
    return inst;
  }

  static SvgPathReader maleFront() => _fromFile('assets/male_front.svg');

  static SvgPathReader maleBack() => _fromFile('assets/male_back.svg');

  /// SVG width (from <svg width="...">)
  double get width {
    _ensureLoaded();
    _loadDimensionsIfNeeded();
    return _width ?? 0.0;
  }

  /// SVG height (from <svg height="...">)
  double get height {
    _ensureLoaded();
    _loadDimensionsIfNeeded();
    return _height ?? 0.0;
  }

  void _loadDimensionsIfNeeded() {
    if (_width != null || _height != null) return;

    final svg = _document!.rootElement;

    _width = _parseSvgLength(svg.getAttribute('width')) ?? 0;
    _height = _parseSvgLength(svg.getAttribute('height')) ?? 0;
  }

  double? _parseSvgLength(String? value) {
    if (value == null) return null;

    // Handles values like "100", "100px", "100.5"
    final numeric = RegExp(r'[\d.]+').firstMatch(value)?.group(0);
    return numeric != null ? double.tryParse(numeric) : null;
  }

  /// Ensures the SVG file is loaded
  void _ensureLoaded() {
    if (_document == null) {
      final content = File(_filePath).readAsStringSync();
      _document = XmlDocument.parse(content);
    }
  }

  /// Returns path's "d" attribute(s) by path id or group id
  List<String> getPathDs(String pathId) {
    _ensureLoaded();
    final id = pathId.toLowerCase();

    // Check caches first
    if (_pathCache.containsKey(id)) return [_pathCache[id]!];
    if (_groupCache.containsKey(id)) return _groupCache[id]!;

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
