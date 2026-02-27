import 'package:bento_clone/core/constants.dart';
import 'package:flutter/material.dart';

// Responsive utilities have moved to lib/core/responsive/breakpoints.dart.
// ScreenSizeUtils and ResponsiveText are kept here as thin wrappers so that
// existing imports continue to compile without changes. New code should import
// from core/responsive/breakpoints.dart directly.
export 'package:bento_clone/core/responsive/breakpoints.dart'
    show Breakpoints, ResponsiveBuilder;

/// For consistent padding and spacing.
class AppInsets {
  static const double xs = 4.0; // Extra Small
  static const double s = 8.0; // Small
  static const double m = 16.0; // Medium
  static const double l = 20.0; // Large
  static const double xl = 24.0; // Extra Large
}

/// For consistent icon sizes.
class AppIconSizes {
  static const double s = 16.0; // Small
  static const double m = 24.0; // Medium (replaces 20px, 25px)
  static const double l = 32.0; // Large (replaces 28px)
  static const double xl = 40.0; // Extra Large
}

/// For consistent border radii.
class AppRadii {
  static final BorderRadius card = BorderRadius.circular(RadiusConstants.card);
  static final BorderRadius chip = BorderRadius.circular(RadiusConstants.chip);
}
