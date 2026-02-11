part of 'core.dart';

class SvgPathReader {
  static final Map<String, SvgPathReader> _instances = {};

  final String _filePath;
  XmlDocument? _document;
  double? _width;
  double? _height;
  BodyView _view = BodyView.both;

  // Cache for path IDs: pathId -> path d
  final Map<String, String> _pathCache = {};

  // Cache for group IDs: groupId -> list of path ds
  final Map<String, List<String>> _groupCache = {};

  SvgPathReader._(this._filePath);

  /// Factory method
  static SvgPathReader _fromFile(String filePath, {required BodyView view}) {
    if (_instances.containsKey(filePath)) {
      return _instances[filePath]!.._view = view;
    }
    final inst = SvgPathReader._(filePath).._view = view;
    _instances[filePath] = inst;
    return inst;
  }

  static SvgPathReader male({BodyView view = BodyView.both}) =>
      _fromFile('assets/male.svg', view: view);

  static SvgPathReader female({BodyView view = BodyView.both}) =>
      _fromFile('assets/female.svg', view: view);

  /// SVG width (from <svg width="...">)
  double get width {
    _ensureLoaded();
    _loadDimensionsIfNeeded();
    final w = _width ?? 0.0;
    if (_view == BodyView.back || _view == BodyView.front) return w / 2;
    return w;
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

  String _pathByView(String d) {
    if (_view != BodyView.back) return d;
    return isRightSidePath(d, 2 * width)
        ? _translatePathData(d, -1 * width)
        : d;
  }

  String _translatePathData(String pathData, double offsetX) {
    final commandRegex = RegExp(
      r'([MmLlHhVvCcSsQqTtAaZz])\s*([^MmLlHhVvCcSsQqTtAaZz]*)',
    );

    return pathData.replaceAllMapped(commandRegex, (match) {
      final cmd = match.group(1)!;
      final params = match.group(2)!;

      // Don't process close path commands
      if (cmd.toUpperCase() == 'Z') {
        return match.group(0)!;
      }

      // Parse numbers while preserving original text between them
      final numberRegex = RegExp(r'(-?\d*\.?\d+(?:[eE][-+]?\d+)?)');
      int paramIndex = 0;
      final isRelative = cmd == cmd.toLowerCase();

      return cmd +
          params.replaceAllMapped(numberRegex, (numMatch) {
            final numStr = numMatch.group(0)!;
            final numValue = double.tryParse(numStr) ?? 0;
            double result = numValue;

            final upperCmd = cmd.toUpperCase();

            // Determine if this is an x coordinate
            bool isXCoord = false;
            if (upperCmd != 'V') {
              if (upperCmd == 'H') {
                isXCoord = true; // H only has x
              } else if (upperCmd == 'A') {
                // Arc: rx,ry,rotation,large-arc,sweep,x,y (x is 6th param)
                isXCoord = paramIndex == 5;
              } else {
                // For M,L,C,S,Q,T: x coordinates are at even indices
                isXCoord = paramIndex % 2 == 0;
              }
            }

            if (isXCoord && !isRelative) {
              result = numValue + offsetX;
            }

            paramIndex++;
            return _formatNumber(result, original: numStr);
          });
    });
  }

  String _formatNumber(double value, {required String original}) {
    // Try to preserve original formatting when possible
    if (value == value.toInt().toDouble()) {
      // Integer value
      final hasDecimal = original.contains('.');
      return hasDecimal ? value.toStringAsFixed(1) : value.toInt().toString();
    }

    // Check if original had specific decimal places
    if (original.contains('.')) {
      final decimalPlaces = original.split('.')[1].length;
      return value.toStringAsFixed(decimalPlaces);
    }

    // Default formatting
    return value.toString();
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
    if (_pathCache.containsKey(id)) {
      return [_pathCache[id]!].map((p) => _pathByView(p)).toList();
    }
    if (_groupCache.containsKey(id)) {
      return (_groupCache[id]!).map((p) => _pathByView(p)).toList();
    }

    final doc = _document!;

    // Try path
    final path = _findPathById(doc.rootElement, id);
    if (path != null) {
      final d = path.getAttribute('d') ?? '';
      _pathCache[id] = d;
      return [d].map((p) => _pathByView(p)).toList();
    }

    // Try group
    final group = _findGroupById(doc.rootElement, id);
    if (group != null) {
      final ds = _collectPathsFromGroup(group);
      _groupCache[id] = ds;
      return ds.map((p) => _pathByView(p)).toList();
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
