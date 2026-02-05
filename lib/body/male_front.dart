part of 'body.dart';

class MaleFront extends _Body {
  static final FrontMuscles muscles = FrontMuscle.male;

  MaleFront({
    super.strokeColor = Colors.black,
    super.strokeWidth = 0.2,
    super.defFillColor = Colors.transparent,
    super.defFillOpacity = 0,
    super.defHighlightColor = Colors.red,
    super.defHighlightOpacity = 0.5,
    super.muscles = const [],
  });

  @override
  SvgElement get _bodySvgElement => SvgGroup(id: 'front')
    ..addStyle('display', 'inline')
    ..addAttribute('transform', 'translate(-10.159436,-6.2156523)');

  @override
  List<Muscle> get _muscles => muscles.all;

  @override
  String get _outlineId => 'outline_front';

  @override
  SvgPathReader get _svgPathReader => SvgPathReader.maleFront();
}
