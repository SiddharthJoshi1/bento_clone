/// App-wide constants for magic numbers.
///
/// Use these instead of hardcoded values throughout the codebase.
/// Grouped by concern so it's easy to find and adjust values.
library;

/// Layout and grid constants.
class LayoutConstants {

  /// Fixed width of a single grid column in the Bento desktop layout.
  static const double columnWidth = 195.0;

  /// Number of columns in the desktop grid.
  static const int desktopColumnCount = 4;

  /// Number of columns in the mobile grid.
  static const int mobileColumnCount = 2;
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
