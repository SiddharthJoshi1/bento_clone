import 'package:flutter/rendering.dart';

class BentoGridLayout extends SliverGridLayout {
  final Map<int, SliverGridGeometry> geometryMap;

  final double totalHeight;

  const BentoGridLayout({required this.geometryMap, required this.totalHeight});

  @override
  double computeMaxScrollOffset(int childCount) {
    return totalHeight;
  }

  @override
  SliverGridGeometry getGeometryForChildIndex(int index) {
    return geometryMap[index]!;
  }

  @override
  int getMaxChildIndexForScrollOffset(double scrollOffset) {
    return geometryMap.length - 1;
  }

  @override
  int getMinChildIndexForScrollOffset(double scrollOffset) {
    return 0;
  }
}
