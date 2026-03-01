import 'package:flutter/material.dart';

import '../../../../../../domain/entities/tile_config.dart';

/// Adapts tile configs and computes heights for the mobile list layout.
///
/// The bento grid uses a masonry-style [SliverGridDelegate] on desktop.
/// On mobile, tiles are rendered in a plain [ListView] instead, so each
/// tile needs an explicit pixel height rather than a column-span dimension.
///
/// [getMobileConfig] maps desktop-oriented [TileSize] values to their
/// closest mobile equivalent so tiles don't dominate the scroll view.
///
/// [getMobileHeight] returns the fixed pixel height for a given [TileSize]
/// as used in the mobile list.
class MobileTileAdapter {

  /// Returns a copy of [original] with its [TileSize] mapped to a
  /// mobile-friendly equivalent. Section title tiles are returned unchanged.
  static TileConfig getMobileConfig(TileConfig original) {
    if (original.type == TileType.sectionTitle) return original;

    switch (original.tileSize) {
      case TileSize.small:
        // Small squares → thin bars (like Linktree links)
        return original.copyWith(tileSize: TileSize.thin);
      case TileSize.standard:
        // Standard rectangles look fine on mobile as-is
        return original;
      case TileSize.fullsize:
        // 4×4 blocks → standard rectangles so they don't dominate
        return original.copyWith(tileSize: TileSize.standard);
      case TileSize.longVertical:
        // Vertical strips → standard rectangles to avoid clipping
        return original.copyWith(tileSize: TileSize.standard);
      case TileSize.longHorizontal:
        // Horizontal strips → thin bars
        return original.copyWith(tileSize: TileSize.thin);
      case TileSize.thin:
        return original;
    }
  }

  /// Returns the pixel height for [size] in the mobile list view.
  static double getMobileHeight(TileSize size, BuildContext context) {
    switch (size) {
      case TileSize.longHorizontal:
        return 100.0;
      case TileSize.thin:
      case TileSize.small:
        return 85.0;
      case TileSize.standard:
      case TileSize.longVertical:
        return 170.0;
      case TileSize.fullsize:
        return 300.0;
    }
  }
}
