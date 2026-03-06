import 'package:flutter/rendering.dart';

import '../bento_item.dart';
import '../bento_sizing_strategy.dart';
import 'bento_grid_layout.dart';
import 'bento_layout_details.dart';
import 'skyline_packing.dart';

/// A [SliverGridDelegate] that uses the skyline bin-packing algorithm.
///
/// Derives column width from [SliverConstraints.crossAxisExtent] so the
/// grid always fills its parent exactly — no fixed pixel widths needed.
class BentoGridDelegate extends SliverGridDelegate {
  const BentoGridDelegate({
    required this.items,
    required this.unitHeight,
    this.strategy,
  });

  final List<BentoItem> items;
  final double unitHeight;
  final BentoSizingStrategy? strategy;

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    final BentoLayoutDetails details = SkylinePacking.pack(
      items: items,
      totalWidth: constraints.crossAxisExtent,
      unitHeight: unitHeight,
      strategy: strategy,
    );

    return BentoGridLayout(
      geometryMap: details.geometryMap,
      totalHeight: details.totalHeight,
    );
  }

  @override
  bool shouldRelayout(BentoGridDelegate oldDelegate) =>
      oldDelegate.items != items ||
      oldDelegate.unitHeight != unitHeight;
}
