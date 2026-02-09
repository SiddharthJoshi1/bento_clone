import 'package:bento_clone/domain/entities/tile_config.dart';
import 'package:bento_clone/presentation/utils/app_styles.dart';
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
    double columnWidth = 195.0; // Fixed column width for better control

    BentoLayoutDetails bentoLayoutDetails =
        LayoutUtils.buildSkylineAndReturnBentoLayoutDetails(
          tiles: tiles,
          columnWidth: columnWidth,
          isMobile: !ScreenSizeUtils.isDesktop(context),
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
