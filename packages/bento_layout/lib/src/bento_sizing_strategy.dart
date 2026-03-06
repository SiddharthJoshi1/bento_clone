import 'bento_dimension.dart';
import 'bento_item_size.dart';

/// Strategy interface for resolving a [BentoItemSize] to its [BentoDimension].
///
/// Implement this to provide custom tile proportions without touching the
/// packing algorithm.
///
/// ```dart
/// class MyStrategy implements BentoSizingStrategy {
///   const MyStrategy();
///   @override
///   BentoDimension getDimensions(BentoItemSize size) {
///     return switch (size) {
///       BentoItemSize.fullTower => const BentoDimension(widthFraction: 1.0, heightSpan: 2.0),
///       _ => const BentoDimension(widthFraction: 0.5, heightSpan: 1.0),
///     };
///   }
/// }
/// ```
abstract interface class BentoSizingStrategy {
  BentoDimension getDimensions(BentoItemSize size);
}

/// Default sizing strategy implementing the 3×3 bento size matrix.
///
/// | BentoItemSize | widthFraction | heightSpan |
/// |---------------|---------------|------------|
/// | quarterBar    | 0.25          | 0.5        |
/// | quarterCard   | 0.25          | 1.0        |
/// | quarterTower  | 0.25          | 2.0        |
/// | halfBar       | 0.5           | 0.5        |
/// | halfCard      | 0.5           | 1.0        |
/// | halfTower     | 0.5           | 2.0        |
/// | fullBar       | 1.0           | 0.5        |
/// | fullCard      | 1.0           | 1.0        |
/// | fullTower     | 1.0           | 2.0        |
class DefaultBentoSizingStrategy implements BentoSizingStrategy {
  const DefaultBentoSizingStrategy();

  @override
  BentoDimension getDimensions(BentoItemSize size) {
    switch (size) {
      case BentoItemSize.quarterBar:
        return const BentoDimension(widthFraction: 0.25, heightSpan: 0.5);
      case BentoItemSize.quarterCard:
        return const BentoDimension(widthFraction: 0.25, heightSpan: 1.0);
      case BentoItemSize.quarterTower:
        return const BentoDimension(widthFraction: 0.25, heightSpan: 2.0);
      case BentoItemSize.halfBar:
        return const BentoDimension(widthFraction: 0.5,  heightSpan: 0.5);
      case BentoItemSize.halfCard:
        return const BentoDimension(widthFraction: 0.5,  heightSpan: 1.0);
      case BentoItemSize.halfTower:
        return const BentoDimension(widthFraction: 0.5,  heightSpan: 2.0);
      case BentoItemSize.fullBar:
        return const BentoDimension(widthFraction: 1.0,  heightSpan: 0.5);
      case BentoItemSize.fullCard:
        return const BentoDimension(widthFraction: 1.0,  heightSpan: 1.0);
      case BentoItemSize.fullTower:
        return const BentoDimension(widthFraction: 1.0,  heightSpan: 2.0);
    }
  }
}
