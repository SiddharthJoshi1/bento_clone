import 'package:flutter/widgets.dart';
import 'bento_item_size.dart';

/// A tile in the bento grid.
///
/// Wrap your own widget in [BentoItem] and pass it to [BentoGrid.items].
///
/// ```dart
/// BentoItem(
///   size: BentoItemSize.halfCard,
///   child: MyLinkTile(),
/// )
/// ```
class BentoItem {
  const BentoItem({
    required this.size,
    required this.child,
  });

  /// The size of this tile in the grid.
  final BentoItemSize size;

  /// The widget rendered inside this tile.
  final Widget child;
}
