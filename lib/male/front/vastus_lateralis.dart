part of 'front_library.dart';

class VastusLateralis extends FrontMuscle {
  VastusLateralis(super.size);

  @override
    get _left => leftVastusLateralis;

  @override
  get _right => rightVastusLateralis;
}
