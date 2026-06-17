part of 'core.dart';

/// A utility class for reading and parsing path data from SVG files.
///
/// It provides mechanisms to retrieve SVG path 'd' attributes by ID,
/// with support for group elements and automatic caching.
class SvgPathReader {
  /// Internal cache to store instances of [SvgPathReader] per file path.
  static final Map<SvgAssetType, SvgPathReader> _instances = {};

  /// Path to the SVG file.
  final SvgAssetType _assetType;

  /// The parsed XML document of the SVG.
  XmlDocument? _document;

  /// Cached width of the SVG.
  double? _width;

  /// Cached height of the SVG.
  double? _height;

  /// Cache for individual path IDs: pathId -> path d string.
  final Map<String, String> _pathCache = {};

  /// Cache for individual path IDs: pathId -> Path object.
  final Map<String, Path> _pathObjectCache = {};

  /// Cache for group IDs: groupId -> list of path d strings.
  final Map<String, List<String>> _groupCache = {};

  /// Cache for group IDs: groupId -> list of Path objects.
  final Map<String, List<Path>> _groupObjectCache = {};

  /// Map of element ID to XML element for fast lookup.
  final Map<String, XmlElement> _elementIndex = {};

  /// Private constructor for [SvgPathReader].
  SvgPathReader._(this._assetType);

  /// Internal factory method to manage [SvgPathReader] instances.
  ///
  /// Ensures that only one instance of [SvgPathReader] exists for a specific [assetType].
  factory SvgPathReader._fromString(SvgAssetType assetType) =>
      _instances.putIfAbsent(assetType, () => SvgPathReader._(assetType));

  /// Returns an [SvgPathReader] for the male body based on the specified [view].
  factory SvgPathReader.male(BodyView view) {
    return switch (view) {
      BodyView.front => SvgPathReader.maleFront(),
      BodyView.back => SvgPathReader.maleBack(),
      _ => throw UnimplementedError(
        'errors.view_not_implemented'.tr(
          namedArgs: {'gender': 'male'.localizedGender, 'view': view.localizedName},
        ),
      ),
    };
  }

  /// Returns an [SvgPathReader] for the female body based on the specified [view].
  factory SvgPathReader.female(BodyView view) {
    return switch (view) {
      BodyView.front => SvgPathReader.femaleFront(),
      BodyView.back => SvgPathReader.femaleBack(),
      _ => throw UnimplementedError(
        'errors.view_not_implemented'.tr(
          namedArgs: {'gender': 'female'.localizedGender, 'view': view.localizedName},
        ),
      ),
    };
  }

  /// Returns an [SvgPathReader] for the male front view.
  factory SvgPathReader.maleFront() =>
      SvgPathReader._fromString(SvgAssetType.maleFront);

  /// Returns an [SvgPathReader] for the female front view.
  factory SvgPathReader.femaleFront() =>
      SvgPathReader._fromString(SvgAssetType.femaleFront);

  /// Returns an [SvgPathReader] for the male back view.
  factory SvgPathReader.maleBack() =>
      SvgPathReader._fromString(SvgAssetType.maleBack);

  /// Returns an [SvgPathReader] for the female back view.
  factory SvgPathReader.femaleBack() =>
      SvgPathReader._fromString(SvgAssetType.femaleBack);

  /// The intrinsic width of the SVG defined in the 'width' attribute.
  double get width {
    _ensureLoaded();
    return _width ?? 0.0;
  }

  /// The intrinsic height of the SVG defined in the 'height' attribute.
  double get height {
    _ensureLoaded();
    return _height ?? 0.0;
  }

  /// Extracts and caches SVG dimensions from the root element.
  void _loadDimensions() {
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

  /// Reads the file from disk, parses the XML, and indexes elements by ID.
  void _ensureLoaded() {
    if (_document == null) {
      final content = getSvgAssetString(_assetType);
      _document = XmlDocument.parse(content);
      _indexElements(_document!.rootElement);
      _loadDimensions();
    }
  }

  /// Recursively indexes all elements that have an 'id' attribute.
  void _indexElements(XmlElement element) {
    final id = element.getAttribute('id')?.toLowerCase();
    if (id != null) {
      _elementIndex[id] = element;
    }
    for (var child in element.children.whereType<XmlElement>()) {
      _indexElements(child);
    }
  }

  /// Returns a list of path 'd' attributes associated with the given [pathId].
  ///
  /// This method uses a flat index for O(1) element lookup and automatically handles 
  /// symmetric muscles by checking for 'left_' and 'right_' prefixes.
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

    // Handle symmetric muscles (left/right) if the base ID wasn't found/cached
    if (!id.contains('outline') &&
        !id.startsWith('left_') &&
        !id.startsWith('right_')) {
      final paths = getPathDs('right_$id') + getPathDs('left_$id');
      if (paths.isNotEmpty) {
        _groupCache[id] = paths;
        return paths;
      }
    }

    final element = _elementIndex[id];
    if (element == null) return [];

    // Try path
    if (element.name.local == 'path') {
      final d = element.getAttribute('d') ?? '';
      _pathCache[id] = d;
      return [d];
    }

    // Try group
    if (element.name.local == 'g') {
      final ds = _collectPathsFromGroup(element);
      _groupCache[id] = ds;
      return ds;
    }

    return [];
  }

  /// Returns a list of [Path] objects associated with the given [pathId].
  ///
  /// This method parses the SVG path data and caches the resulting [Path] objects
  /// for subsequent calls.
  List<Path> getPaths(String pathId) {
    _ensureLoaded();
    final id = pathId.toLowerCase();

    if (_pathObjectCache.containsKey(id)) {
      return [_pathObjectCache[id]!];
    }
    if (_groupObjectCache.containsKey(id)) {
      return _groupObjectCache[id]!;
    }

    // Handle symmetric muscles (left/right) if the base ID wasn't found/cached
    if (!id.contains('outline') &&
        !id.startsWith('left_') &&
        !id.startsWith('right_')) {
      final paths = getPaths('right_$id') + getPaths('left_$id');
      if (paths.isNotEmpty) {
        _groupObjectCache[id] = paths;
        return paths;
      }
    }

    final ds = getPathDs(pathId);
    if (ds.isEmpty) return [];

    if (ds.length == 1) {
      final path = parseSvgPathData(ds.first);
      _pathObjectCache[id] = path;
      return [path];
    } else {
      final paths = ds.map((d) => parseSvgPathData(d)).toList();
      _groupObjectCache[id] = paths;
      return paths;
    }
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
