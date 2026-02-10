import 'package:flutter/material.dart';

// --- SIZING CONSTANTS ---
// Based on a 4px grid for consistency.

class ScreenSizeUtils {
  // Breakpoints
  static const double desktopBreakpoint = 1200;
  static const double tabletBreakpoint = 800;
  static const double narrowBreakpoint = 425; // For very small screens

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopBreakpoint;
  }

  static bool isNarrow(BuildContext context) {
    return MediaQuery.of(context).size.width < narrowBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width > narrowBreakpoint && width < desktopBreakpoint;
  }
}

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
  static final BorderRadius card = BorderRadius.circular(24.0);
  static final BorderRadius chip = BorderRadius.circular(12.0); // Replaces 10px
}

// --- RESPONSIVE TYPOGRAPHY ---

/// A utility class to get responsive font sizes based on screen width.
class ResponsiveText {
  // Base font sizes for mobile
  static const double _baseTitleLarge = 22.0;
  static const double _baseTitleMedium = 18.0;
  static const double _baseTitleSmall = 16.0;
  static const double _baseLabelLarge = 14.0;
  static const double _baseLabelMedium = 13.0;
  static const double _baseLabelSmall = 12.0;
  static const double _baseCaption = 12.0; // For smaller text like URLs

  /// Style for large titles (e.g., Section Headers).
  static TextStyle? titleLarge(BuildContext context) {
    return Theme.of(context).textTheme.titleLarge?.copyWith(
      fontSize: _getResponsiveFontSize(context, _baseTitleLarge),
    );
  }

  /// Style for medium titles (e.g., Text tile content).
  static TextStyle? titleMedium(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium?.copyWith(
      fontSize: _getResponsiveFontSize(context, _baseTitleMedium),
    );
  }

  /// Style for small titles (e.g., Link tile titles).
  static TextStyle? titleSmall(BuildContext context) {
    return Theme.of(context).textTheme.titleSmall?.copyWith(
      fontSize: _getResponsiveFontSize(context, _baseTitleSmall),
    );
  }

  /// Style for labels (e.g., Text tile in thin layout).
  static TextStyle? labelLarge(BuildContext context) {
    return Theme.of(context).textTheme.labelLarge?.copyWith(
      fontSize: _getResponsiveFontSize(context, _baseLabelLarge),
    );
  }

  /// Style for labels (e.g., Text tile in thin layout).
  static TextStyle? labelMedium(BuildContext context) {
    return Theme.of(context).textTheme.labelMedium?.copyWith(
      fontSize: _getResponsiveFontSize(context, _baseLabelMedium),
    );
  }

  /// Style for labels (e.g., Text tile in thin layout).
  static TextStyle? labelSmall(BuildContext context) {
    return Theme.of(context).textTheme.labelSmall?.copyWith(
      fontSize: _getResponsiveFontSize(context, _baseLabelSmall),
    );
  }

  /// Style for captions (e.g., URLs and map labels).
  static TextStyle? caption(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall?.copyWith(
      fontSize: _getResponsiveFontSize(context, _baseCaption),
      color: Colors.grey.shade600,
    );
  }

  /// Calculates the final font size based on screen width.
  static double _getResponsiveFontSize(BuildContext context, double baseSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > ScreenSizeUtils.desktopBreakpoint) {
      // Desktop: Larger text
      return baseSize * 1.2;
    } else if (screenWidth > ScreenSizeUtils.tabletBreakpoint) {
      // Tablet: Slightly larger text
      return baseSize * 1.1;
    } else {
      // Mobile: Base size
      return baseSize;
    }
  }
}
