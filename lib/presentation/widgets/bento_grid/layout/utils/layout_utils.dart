import 'package:flutter/rendering.dart';

import '../../../../../domain/entities/tile_config.dart';
import 'size_utils.dart';

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
  }) {
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
      GridDimension gridDimension = isMobile
          ? GridSizeUtils.getMobileGridDimensions(tile.tileSize)
          : GridSizeUtils.getDesktopGridDimensions(tile.tileSize);
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
