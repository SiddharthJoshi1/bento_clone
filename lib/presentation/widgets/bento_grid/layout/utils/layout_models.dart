import 'package:flutter/rendering.dart';

/// The result of running the skyline packing algorithm over a tile list.
///
/// Contains the total scrollable height of the grid and a geometry entry
/// for every tile index, ready to be handed to [BentoGridLayout].
class BentoLayoutDetails {
  const BentoLayoutDetails({
    required this.totalHeight,
    required this.geometryMap,
  });

  /// The height of the tallest column — used as the grid's total scroll extent.
  final double totalHeight;

  /// Maps each tile index to its [SliverGridGeometry] (position + size).
  final Map<int, SliverGridGeometry> geometryMap;
}
