import 'package:flutter/rendering.dart';

/// The result of running the skyline packing algorithm over an item list.
class BentoLayoutDetails {
  const BentoLayoutDetails({
    required this.totalHeight,
    required this.geometryMap,
  });

  /// Height of the tallest column — used as the grid's total scroll extent.
  final double totalHeight;

  /// Maps each item index to its [SliverGridGeometry].
  final Map<int, SliverGridGeometry> geometryMap;
}
