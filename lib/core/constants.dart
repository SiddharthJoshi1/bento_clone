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

/// Map tile constants.
class MapConstants {
  /// Raster tile URL template for the map tile renderer.
  /// Swap this to change the map style — no other code changes needed.
  ///
  /// Current: OSM Standard (free, open, attribution required).
  /// Alternative: Maptiler — 'https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key=YOUR_KEY'
  static const String tileUrlTemplate =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

  /// User-agent package name sent with tile requests.
  /// OSM policy requires a clear, unique identifier — do not change to a generic value.
  static const String userAgentPackageName = 'dev.builtbysid.bento_clone';

  /// Default zoom level for map tiles.
  static const double defaultZoom = 14.0;
}

/// Remote content constants.
class RemoteConstants {
  /// Raw GitHub URL serving content.json from the `content` branch.
  /// Push to that branch to update the live portfolio — no rebuild needed.
  static const String baseContentUrl = "https://raw.githubusercontent.com/SiddharthJoshi1/bento_clone/content/"; 

  static const String contentJsonUrlPath = 
      '${baseContentUrl}assets/data/content.json';
  

  /// SharedPreferences key for the cached content JSON string.
  static const String contentCacheKey = 'cached_content_json';

  /// SharedPreferences key for the cached content version string.
  static const String contentVersionKey = 'cached_content_version';

  /// Timeout for remote fetch requests.
  static const Duration fetchTimeout = Duration(seconds: 8);
}

/// Analytics constants.
class AnalyticsConstants {
  /// Lukehog app ID.
  static const String lukehogAppId = String.fromEnvironment(
    'LUKEHOG_APP_ID',
  );
}
