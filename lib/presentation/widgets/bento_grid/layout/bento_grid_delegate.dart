import 'package:bento_clone/core/constants.dart';
import 'package:bento_clone/core/responsive/breakpoints.dart';
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
    double columnWidth = LayoutConstants.columnWidth;

    BentoLayoutDetails bentoLayoutDetails =
        LayoutUtils.buildSkylineAndReturnBentoLayoutDetails(
          tiles: tiles,
          columnWidth: columnWidth,
          isMobile: !Breakpoints.isDesktop(context),
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
