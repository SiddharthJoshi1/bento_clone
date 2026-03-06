import 'package:flutter/rendering.dart';

/// A [SliverGridLayout] that serves pre-computed tile geometry.
///
/// All layout work is done upfront in [SkylinePacking.pack] —
/// this class just hands the results to Flutter on demand.
class BentoGridLayout extends SliverGridLayout {
  const BentoGridLayout({
    required this.geometryMap,
    required this.totalHeight,
  });

  final Map<int, SliverGridGeometry> geometryMap;
  final double totalHeight;

  @override
  double computeMaxScrollOffset(int childCount) => totalHeight;

  @override
  SliverGridGeometry getGeometryForChildIndex(int index) =>
      geometryMap[index]!;

  @override
  int getMaxChildIndexForScrollOffset(double scrollOffset) =>
      geometryMap.length - 1;

  @override
  int getMinChildIndexForScrollOffset(double scrollOffset) => 0;
}
