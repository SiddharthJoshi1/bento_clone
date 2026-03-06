import 'package:flutter/material.dart';

import 'bento_item.dart';
import 'bento_sizing_strategy.dart';
import 'layout/bento_grid_delegate.dart';

/// A scrollable bento grid that positions tiles of varying sizes using
/// the skyline bin-packing algorithm.
///
/// Tile widths are expressed as fractions of the available width — no column
/// count or fixed pixel widths needed. The grid always fills its parent.
///
/// ```dart
/// BentoGrid(
///   unitHeight: 180,
///   items: [
///     BentoItem(size: BentoItemSize.fullTower, child: HeroTile()),
///     BentoItem(size: BentoItemSize.halfCard,  child: LinkTile()),
///     BentoItem(size: BentoItemSize.halfCard,  child: LinkTile()),
///     BentoItem(size: BentoItemSize.fullBar,   child: SectionTitle()),
///   ],
/// )
/// ```
class BentoGrid extends StatelessWidget {
  const BentoGrid({
    super.key,
    required this.items,
    this.unitHeight = 180.0,
    this.strategy,
    this.padding,
    this.physics,
    this.primary,
    this.shrinkWrap = false,
  });

  /// The tiles to display in the grid.
  final List<BentoItem> items;

  /// Height of one row unit in pixels.
  ///
  /// All tile heights are a multiple of this value:
  /// - Bar tiles: `unitHeight * 0.5`
  /// - Card tiles: `unitHeight * 1.0`
  /// - Tower tiles: `unitHeight * 2.0`
  ///
  /// Defaults to `180.0`.
  final double unitHeight;

  /// Custom sizing strategy. Defaults to [DefaultBentoSizingStrategy].
  final BentoSizingStrategy? strategy;

  /// Padding around the grid.
  final EdgeInsetsGeometry? padding;

  /// Scroll physics. Defaults to the platform default.
  final ScrollPhysics? physics;

  /// Whether this is the primary scroll view.
  final bool? primary;

  /// Whether the grid should shrink-wrap its content.
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      primary: primary,
      physics: physics,
      shrinkWrap: shrinkWrap,
      slivers: [
        SliverPadding(
          padding: padding ?? EdgeInsets.zero,
          sliver: SliverGrid(
            gridDelegate: BentoGridDelegate(
              items: items,
              unitHeight: unitHeight,
              strategy: strategy,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => items[index].child,
              childCount: items.length,
            ),
          ),
        ),
      ],
    );
  }
}
