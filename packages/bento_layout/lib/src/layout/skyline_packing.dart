import 'package:flutter/rendering.dart';

import '../bento_item.dart';
import '../bento_sizing_strategy.dart';
import 'bento_layout_details.dart';

/// Implements the skyline bin-packing algorithm for the bento grid.
///
/// Maintains a pixel-based skyline — an array of bottom-edge heights, one
/// slot per smallest-fraction unit of the total width. For each item:
///
///   1. Resolve [widthFraction] and [heightSpan] via the sizing strategy.
///   2. Derive pixel dimensions from [totalWidth] and [unitHeight].
///   3. Scan every valid x slot and place the item at the lowest position.
///   4. Raise the skyline and record the [SliverGridGeometry].
class SkylinePacking {
  const SkylinePacking._();

  static BentoLayoutDetails pack({
    required List<BentoItem> items,
    required double totalWidth,
    required double unitHeight,
    BentoSizingStrategy? strategy,
  }) {
    final BentoSizingStrategy sizingStrategy =
        strategy ?? const DefaultBentoSizingStrategy();

    // Find the smallest widthFraction across all items to determine
    // skyline slot granularity.
    // e.g. 0.25 → 4 slots, 0.5 → 2 slots, 1.0 → 1 slot.
    double smallestFraction = 1.0;
    for (final item in items) {
      final double f = sizingStrategy.getDimensions(item.size).widthFraction;
      if (f < smallestFraction) smallestFraction = f;
    }

    final double slotWidth = totalWidth * smallestFraction;
    final int slotCount = (totalWidth / slotWidth).round();
    final List<double> skyline = List.filled(slotCount, 0);

    final Map<int, SliverGridGeometry> geometry = {};

    for (int i = 0; i < items.length; i++) {
      final item = items[i];

      // A. Resolve dimensions.
      final dim = sizingStrategy.getDimensions(item.size);
      final double pixelWidth = dim.widthFraction * totalWidth;
      final double pixelHeight = dim.heightSpan * unitHeight;
      final int tileSlots = (pixelWidth / slotWidth).round();

      // B. Find lowest valid starting slot.
      int bestSlot = 0;
      double bestY = double.infinity;

      for (int slot = 0; slot <= slotCount - tileSlots; slot++) {
        double maxY = 0;
        for (int s = 0; s < tileSlots; s++) {
          if (skyline[slot + s] > maxY) maxY = skyline[slot + s];
        }
        if (maxY < bestY) {
          bestY = maxY;
          bestSlot = slot;
        }
      }

      // C. Pixel position.
      final double xOffset = bestSlot * slotWidth;

      // D. Raise skyline.
      for (int s = 0; s < tileSlots; s++) {
        skyline[bestSlot + s] = bestY + pixelHeight;
      }

      // E. Record geometry.
      geometry[i] = SliverGridGeometry(
        scrollOffset: bestY,
        crossAxisOffset: xOffset,
        mainAxisExtent: pixelHeight,
        crossAxisExtent: pixelWidth,
      );
    }

    final double totalHeight = skyline.reduce((a, b) => a > b ? a : b);

    return BentoLayoutDetails(
      totalHeight: totalHeight,
      geometryMap: geometry,
    );
  }
}
