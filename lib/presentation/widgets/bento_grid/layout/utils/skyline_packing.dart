import 'package:flutter/rendering.dart';

import '../../../../../../domain/entities/tile_config.dart';
import '../../../../utils/grid_size_utils.dart';
import 'layout_models.dart';

/// Implements the skyline bin-packing algorithm for the bento grid.
///
/// The "skyline" is an array of column heights that tracks where the next
/// tile can be placed in each column. For each tile we:
///
///   1. Map the [TileSize] enum to column-span × row-span numbers.
///   2. Scan every valid starting column and find the lowest available spot
///      that can fit the tile's width.
///   3. Record the tile's final [SliverGridGeometry] and raise the skyline.
///
/// The result is a [BentoLayoutDetails] containing every tile's position,
/// ready to be consumed by [BentoGridLayout].
class SkylinePacking {

  static BentoLayoutDetails pack({
    required List<TileConfig> tiles,
    required double columnWidth,
    bool isMobile = false,
    TileSizingStrategy? strategy,
  }) {
    final TileSizingStrategy sizingStrategy = strategy ??
        (isMobile
            ? const MobileSizingStrategy()
            : const DesktopSizingStrategy());

    final int numberOfColumns = isMobile ? 2 : 4;
    final List<double> colHeights = List.filled(numberOfColumns, 0);

    // 1 row unit = 1 column width — keeps the grid square by default.
    final double unitHeight = columnWidth;

    final Map<int, SliverGridGeometry> geometry = {};

    for (int i = 0; i < tiles.length; i++) {
      final tile = tiles[i];

      // A. Resolve tile dimensions from the sizing strategy.
      final GridDimension dim = sizingStrategy.getDimensions(tile.tileSize);
      final int spanWidth = dim.width;       // columns
      final double spanHeight = dim.height;  // row units

      // B. Find the lowest valid starting column for this tile.
      int bestCol = 0;
      double bestY = double.infinity;

      for (int col = 0; col <= numberOfColumns - spanWidth; col++) {
        // The tile must sit on top of the tallest column in its span.
        double maxY = 0;
        for (int s = 0; s < spanWidth; s++) {
          if (colHeights[col + s] > maxY) maxY = colHeights[col + s];
        }
        if (maxY < bestY) {
          bestY = maxY;
          bestCol = col;
        }
      }

      // C. Compute pixel geometry.
      final double xOffset = bestCol * columnWidth;
      final double pixelWidth = spanWidth * columnWidth;
      final double pixelHeight = spanHeight * unitHeight;

      // D. Raise the skyline across the tile's span.
      for (int s = 0; s < spanWidth; s++) {
        colHeights[bestCol + s] = bestY + pixelHeight;
      }

      // E. Record the result.
      geometry[i] = SliverGridGeometry(
        scrollOffset: bestY,
        crossAxisOffset: xOffset,
        mainAxisExtent: pixelHeight,
        crossAxisExtent: pixelWidth,
      );
    }

    final double totalHeight =
        colHeights.reduce((a, b) => a > b ? a : b);

    return BentoLayoutDetails(
      totalHeight: totalHeight,
      geometryMap: geometry,
    );
  }
}
