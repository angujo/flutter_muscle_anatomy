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

  final BodyView _view;

  /// The parsed XML document of the SVG.
  XmlDocument? _document;

  /// Cached width of the SVG.
  double? _width;

  /// Cached height of the SVG.
  double? _height;

  /// Returns the list of muscles visible in this view.
  List<Muscle> get muscles => Muscle.forView(_view);

  /// Cache for individual path IDs: pathId -> path d string.
  final Map<String, String> _pathCache = {};

  /// Cache for individual path IDs: pathId -> Path object.
  final Map<String, List<Path>> _pathObjectCache = {};

  /// Cache for group IDs: groupId -> list of path d strings.
  final Map<String, List<String>> _groupCache = {};

  /// Map of element ID to XML element for fast lookup.
  final Map<String, XmlElement> _elementIndex = {};

  /// Cache for muscle locations: (Muscle, MusclePosition) -> MuscleLoc.
  Map<MuscleInstance, SVGPathData>? _muscleLocCache;

  //region Loaders
  /// Private constructor for [SvgPathReader].
  SvgPathReader._(this._assetType, this._view) {
    _loadDocument();
    _loadMuscles();
  }

  void _loadMuscles() {
    if (_muscleLocCache != null) return;

    final cache = <MuscleInstance, SVGPathData>{};
    for (final muscle in muscles) {
      for (final side in MuscleSide.actual()) {
        final loc = MuscleInstance(muscle: muscle, position: side);
        final paths = getPathDs(loc.svgReadId);
        if (paths.isNotEmpty) {
          cache[loc] = SVGPathData(svgPaths: paths);
        }
      }
    }
    _muscleLocCache = cache;
  }

  /// Internal factory method to manage [SvgPathReader] instances.
  ///
  /// Ensures that only one instance of [SvgPathReader] exists for a specific [assetType].
  factory SvgPathReader._fromString(SvgAssetType assetType, BodyView view) =>
      _instances.putIfAbsent(assetType, () => SvgPathReader._(assetType, view));

  /// Returns an [SvgPathReader] for the male body based on the specified [view].
  factory SvgPathReader.male(BodyView view) {
    return switch (view) {
      BodyView.front => SvgPathReader.maleFront(),
      BodyView.back => SvgPathReader.maleBack(),
      _ => throw UnimplementedError(
        MuscleAnatomyLocalization.translator(
          'errors.view_not_implemented',
          namedArgs: {
            'gender': 'male'.localizedGender,
            'view': view.localizedName,
          },
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
        MuscleAnatomyLocalization.translator(
          'errors.view_not_implemented',
          namedArgs: {
            'gender': 'female'.localizedGender,
            'view': view.localizedName,
          },
        ),
      ),
    };
  }

  /// Returns an [SvgPathReader] for the male front view.
  factory SvgPathReader.maleFront() =>
      SvgPathReader._fromString(SvgAssetType.maleFront, BodyView.front);

  /// Returns an [SvgPathReader] for the female front view.
  factory SvgPathReader.femaleFront() =>
      SvgPathReader._fromString(SvgAssetType.femaleFront, BodyView.front);

  /// Returns an [SvgPathReader] for the male back view.
  factory SvgPathReader.maleBack() =>
      SvgPathReader._fromString(SvgAssetType.maleBack, BodyView.back);

  /// Returns an [SvgPathReader] for the female back view.
  factory SvgPathReader.femaleBack() =>
      SvgPathReader._fromString(SvgAssetType.femaleBack, BodyView.back);

  //endregion

  /// Returns the [SVGPathData] for a specific [muscle] at a given [position].
  SVGPathData? getPathData(Muscle muscle, {required MuscleSide position}) =>
      getMuscleData()[MuscleInstance(muscle: muscle, position: position)];

  /// Returns a map of all muscle instances and their corresponding path data.
  Map<MuscleInstance, SVGPathData> getMuscleData() {
    return _muscleLocCache!;
  }

  /// The intrinsic width of the SVG defined in the 'width' attribute.
  double get width => _width ?? 0.0;

  /// The intrinsic height of the SVG defined in the 'height' attribute.
  double get height => _height ?? 0.0;

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
  void _loadDocument() {
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
  List<String> getPathDs(dynamic pathSource) {
    if (pathSource is MuscleInstance) {
      pathSource = pathSource.svgReadId;
    }
    if (pathSource is! String) {
      throw ArgumentError.value('pathSource', 'Must be a String or MuscleLoc');
    }
    final id = pathSource.toLowerCase();

    // Check caches first
    if (_pathCache.containsKey(id)) {
      return [_pathCache[id]!];
    }
    if (_groupCache.containsKey(id)) {
      return _groupCache[id]!;
    }

    // Handle symmetric muscles (left/right) if the base ID wasn't found/cached
    if (!id.contains('outline') && !MuscleSide.isPositionedPath(pathSource)) {
      final paths = MuscleSide.actual()
          .map((pos) => getPathDs('${pos.name}_$id'))
          .flattened
          .toList();
      if (paths.isNotEmpty) {
        _groupCache[id] = paths;
        return paths;
      }
    }

    final element = _elementIndex[id];
    if (element == null) {
      return [];
    }

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
  List<Path> getPaths(String pathId) => _pathObjectCache.putIfAbsent(
    pathId,
    () => getPathDs(pathId).map((pd) => parseSvgPathData(pd)).toList(),
  );

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
