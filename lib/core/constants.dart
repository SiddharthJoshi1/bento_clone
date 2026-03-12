/// App-wide constants for magic numbers.
///
/// Use these instead of hardcoded values throughout the codebase.
/// Grouped by concern so it's easy to find and adjust values.
library;

/// Layout and grid constants.
class LayoutConstants {
  /// The height of one row unit in pixels.
  /// Decoupled from width so tile heights stay consistent across all
  /// screen sizes regardless of how wide the grid is.
  static const double unitHeight = 180.0;
}

/// Border radius constants.
class RadiusConstants {
  /// Large card border radius (used on Bento tiles).
  static const double card = 24.0;

  /// Small chip/icon card border radius.
  static const double chip = 12.0;
}

/// Animation duration constants.
class AnimationConstants {
  /// Duration for the tile hover/press scale animation (milliseconds).
  static const int tileScaleDuration = 200;
}

/// Analytics constants.
class AnalyticsConstants {
  /// Lukehog app ID.
  static const String lukehogAppId = String.fromEnvironment(
    'LUKEHOG_APP_ID',
  );
}
