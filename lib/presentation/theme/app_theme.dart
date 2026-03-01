/// Centralised theme configuration for the Bento app.
///
/// All design tokens live here — colours, spacing, icon sizes, radii, and the
/// full [ThemeData] instance. Import this file instead of reaching into
/// individual utility classes.
///
/// Usage:
/// ```dart
/// // In main.dart
/// theme: AppTheme.light,
///
/// // In widgets
/// color: AppColors.accent,
/// padding: EdgeInsets.all(AppInsets.m),
/// ```
library;

import 'package:bento_clone/core/constants.dart';
import 'package:bento_clone/core/theme/theme_flavour.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ---------------------------------------------------------------------------
// Colours
// ---------------------------------------------------------------------------

/// Semantic colour definitions for the Bento app.
///
/// Use these instead of raw [Colors] values so the palette can be updated
/// in one place, and dark mode support can be added later.
class AppColors {
  // -- Surfaces --
  /// Default scaffold / page background.
  static const Color background = Colors.white;

  /// Card surface colour for tiles without a brand colour.
  static const Color cardSurface = Colors.white;

  /// Transparent — used for image and section-title tiles.
  static const Color tileSurfaceTransparent = Colors.transparent;

  // -- Text --
  /// Primary text on light backgrounds.
  static const Color textPrimary = Colors.black;

  /// Primary text on dark tile backgrounds.
  static const Color textOnDark = Colors.white;

  /// Subdued text, e.g. URL captions.
  static final Color textSubdued = Colors.grey.shade600;

  // -- Borders --
  /// Subtle border used on tile cards.
  static const Color tileBorder = Colors.black12;

  // -- Tile overlays --
  /// Bottom gradient start (transparent) for image tiles.
  static const Color imageGradientStart = Colors.transparent;

  /// Bottom gradient end (dark) for image tiles.
  static final Color imageGradientEnd = Colors.black.withValues(alpha: 0.6);

  // -- Map tile placeholder --
  static final Color mapBackground = Colors.blue[100]!;
  static const Color mapPin = Colors.red;
  static const Color mapLabelBackground = Colors.white;
}

// ---------------------------------------------------------------------------
// Spacing
// ---------------------------------------------------------------------------

/// Padding and spacing values based on a 4px grid.
///
/// @deprecated Prefer importing [AppTheme] — this class is kept for
/// compatibility with existing code.
class AppInsets {
  static const double xs = 4.0;
  static const double s = 8.0;
  static const double m = 16.0;
  static const double l = 20.0;
  static const double xl = 24.0;

  /// Large panel inset — used for the desktop profile side panel.
  static const double xxl = 48.0;
}

// ---------------------------------------------------------------------------
// Icon sizes
// ---------------------------------------------------------------------------

/// Consistent icon sizes across the app.
///
/// @deprecated Prefer importing [AppTheme] — this class is kept for
/// compatibility with existing code.
class AppIconSizes {
  static const double s = 16.0;
  static const double m = 24.0;
  static const double l = 32.0;
  static const double xl = 40.0;
}

// ---------------------------------------------------------------------------
// Border radii
// ---------------------------------------------------------------------------

/// Consistent border radii across the app.
///
/// @deprecated Prefer importing [AppTheme] — this class is kept for
/// compatibility with existing code.
class AppRadii {
  static final BorderRadius card = BorderRadius.circular(RadiusConstants.card);
  static final BorderRadius chip = BorderRadius.circular(RadiusConstants.chip);
}

// ---------------------------------------------------------------------------
// Theme
// ---------------------------------------------------------------------------

/// The single source of truth for [ThemeData] in the Bento app.
///
/// Use [AppTheme.light] in [MaterialApp.theme]. A [dark] getter is stubbed
/// out ready for dark mode support.
///
/// Example:
/// ```dart
/// MaterialApp(
///   theme: AppTheme.light,
///   ...
/// )
/// ```
class AppTheme {
  AppTheme._();

  /// Builds a [ThemeData] for the given [variant] and [brightness].
  static ThemeData _build(ThemeVariant variant, Brightness brightness) {
    final base = brightness == Brightness.light
        ? GoogleFonts.interTextTheme()
        : GoogleFonts.interTextTheme(
            ThemeData(brightness: Brightness.dark).textTheme,
          );

    return ThemeData(
      scaffoldBackgroundColor: variant.background,
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: variant.accent,
        brightness: brightness,
        surface: variant.background,
      ),
      textTheme: base.apply(
        bodyColor: variant.textColour,
        displayColor: variant.textColour,
      ),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(borderRadius: AppRadii.card),
      ),
    );
  }

  /// Light [ThemeData] built from [variant].
  static ThemeData light(ThemeVariant variant) =>
      _build(variant, Brightness.light);

  /// Dark [ThemeData] built from [variant].
  static ThemeData dark(ThemeVariant variant) =>
      _build(variant, Brightness.dark);
}
