import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../../../domain/entities/tile_config.dart';
import '../../../../utils/grid_size_utils.dart';

class BentoLayoutDetails {
  final double totalHeight;
  final Map<int, SliverGridGeometry> geometryMap;

  BentoLayoutDetails({required this.totalHeight, required this.geometryMap});
}

class LayoutUtils {
  static BentoLayoutDetails buildSkylineAndReturnBentoLayoutDetails({
    required List<TileConfig> tiles,
    required double columnWidth,
    bool isMobile = false,
    TileSizingStrategy? strategy,
  }) {
    final TileSizingStrategy sizingStrategy =
        strategy ?? (isMobile ? const MobileSizingStrategy() : const DesktopSizingStrategy());

    final Map<int, SliverGridGeometry> geometry = {};
    // Setup the "Skyline" (Tracking the bottom of each column)
    // We start with 4 columns, all at Y=0.
    int numberOfColumns = isMobile ? 2 : 4;

    List<double> colHeights = List.generate(numberOfColumns, (int index) => 0);

    // We define how tall 1 "row unit" is.
    // Usually in Bento grids, 1 row unit = 1 column width (Square grid).
    final double unitHeight = columnWidth;

    for (int i = 0; i < tiles.length; i++) {
      final tile = tiles[i];

      // A. MAP THE ENUM TO NUMBERS
      GridDimension gridDimension = sizingStrategy.getDimensions(tile.tileSize);
      int crossAxisCount = gridDimension.width; // Width in columns (1-4)
      double mainAxisCount = gridDimension.height; // Height in units

      // B. FIND THE BEST COLUMN TO START IN
      // We are looking for the "lowest" set of columns that can fit our width.

      int bestColumnIndex = 0;
      double bestVerticalPositionValue = double.infinity;

      // We scan possible starting positions.
      // e.g. If width is 2, we check indexes: 0, 1, 2 (we can't start at 3)
      for (
        int columnIndex = 0;
        columnIndex <= (numberOfColumns - crossAxisCount);
        columnIndex++
      ) {
        // Find the height of the tallest column in this span.
        // (Because we can't overlap, we have to sit on top of the tallest thing here)
        double maxHeightInRowSpan = 0;
        for (int span = 0; span < crossAxisCount; span++) {
          if (colHeights[columnIndex + span] > maxHeightInRowSpan) {
            maxHeightInRowSpan = colHeights[columnIndex + span];
          }
        }

        // Is this spot lower (better) than our current best?
        if (maxHeightInRowSpan < bestVerticalPositionValue) {
          bestVerticalPositionValue = maxHeightInRowSpan;
          bestColumnIndex = columnIndex;
        }
      }

      // C. CALCULATE FINAL GEOMETRY
      // x = column index * width of one column
      // y = the best Y we found
      final double xOffset = bestColumnIndex * columnWidth;
      final double yOffset = bestVerticalPositionValue;

      final double pixelWidth = crossAxisCount * columnWidth;
      final double pixelHeight = mainAxisCount * unitHeight;

      for (int columnIndex = 0; columnIndex < crossAxisCount; columnIndex++) {
        colHeights[bestColumnIndex + columnIndex] = yOffset + pixelHeight;
      }

      // D. SAVE THE RESULT (Piece 1)
      geometry[i] = SliverGridGeometry(
        scrollOffset: yOffset,
        crossAxisOffset: xOffset,
        mainAxisExtent: pixelHeight,
        crossAxisExtent: pixelWidth,
      );
    }
    // 3. Final Calculation
    // The total scrollable height is just the tallest column at the end.
    double totalHeight = colHeights.reduce(
      (curr, next) => curr > next ? curr : next,
    );

    return BentoLayoutDetails(totalHeight: totalHeight, geometryMap: geometry);
  }
}

class MobileConfigMapper {
  // inside MobileConfigMapper class...

  static double getMobileHeight(TileSize size, BuildContext context) {

    switch (size) {
      case TileSize.longHorizontal:
        return 100.0; // Thin horizontal bars should be compact

      case TileSize.thin:
      case TileSize.small:
        return 85.0; // Compact bar height

      case TileSize.standard:
      case TileSize.longVertical:
        return 170.0;

      case TileSize.fullsize:
        return 300.0; // Large square
    }
  }

  static TileConfig getMobileConfig(TileConfig original) {
    // If it's a Section Title, keep it as is
    if (original.type == TileType.sectionTitle) {
      return original;
    }

    // On Mobile, we generally want things to be full-width bars (thin)
    // or standard rectangles. Massive squares (fullsize) often take up too much
    // vertical scrolling space on mobile.

    switch (original.tileSize) {
      // Convert Small squares to Thin bars (like Linktree links)
      case TileSize.small:
        return original.copyWith(tileSize: TileSize.thin);

      // Keep Standard (rectangular) as is, they look good on mobile
      case TileSize.standard:
        return original;

      // Shrink massive 4x4 blocks to Standard rectangles so they don't dominate the screen
      case TileSize.fullsize:
        return original.copyWith(tileSize: TileSize.standard);

      // Vertical strips usually need to become standard rectangles or they get cut off
      case TileSize.longVertical:
        return original.copyWith(tileSize: TileSize.standard);

      // Horizontal strips work fine as thin bars
      case TileSize.longHorizontal:
        return original.copyWith(tileSize: TileSize.thin);

      // Default fallback
      case TileSize.thin:
        return original;
    }
  }
}
