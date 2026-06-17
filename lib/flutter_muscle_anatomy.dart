/// A Flutter library for displaying and interacting with muscle anatomy models.
///
/// It supports both male and female body types, front and back views,
/// and allows for precise muscle highlighting.
library;

export 'body/body.dart' show Male, Female, MuscleAnatomy, Anatomy;
export 'core/core.dart'
    show
        Muscle,
        MusclePosition,
        BodyView,
        MuscleLocalization,
        BodyViewLocalization,
        MusclePositionLocalization,
        GenderLocalization,
        MuscleAnatomyLocalization;
