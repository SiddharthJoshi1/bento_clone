import 'package:bento_clone/domain/entities/tile_config.dart';
// ignore: unused_import
import 'package:bento_clone/presentation/utils/sizing_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'bento_grid_layout.dart';
import 'utils/layout_utils.dart';

class BentoGridDelegate extends SliverGridDelegate {
  final List<TileConfig> tiles;
  final BuildContext context;

  BentoGridDelegate({required this.tiles, required this.context});

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    // How wide is the screen?
    final double screenWidth = constraints.crossAxisExtent;

    // How wide is one "column"? (We are assuming a 4-column grid)
    int numberOfColumns = !SizingUtils.isDesktop(context) ? 2 : 4;
    double columnWidth = screenWidth / numberOfColumns;

    BentoLayoutDetails bentoLayoutDetails =
        LayoutUtils.buildSkylineAndReturnBentoLayoutDetails(
          tiles: tiles,
          columnWidth: columnWidth,
          isMobile: !SizingUtils.isDesktop(context),
        );

    return BentoGridLayout(
      geometryMap: bentoLayoutDetails.geometryMap,
      totalHeight: bentoLayoutDetails.totalHeight,
    );
  }

  @override
  bool shouldRelayout(BentoGridDelegate oldDelegate) {
    // If the list of tiles changed, we need to re-calculate.
    return oldDelegate.tiles != tiles;
  }
}
