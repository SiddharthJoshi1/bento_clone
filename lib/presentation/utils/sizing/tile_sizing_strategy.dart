import 'package:bento_clone/domain/entities/tile_config.dart';
import 'package:bento_clone/presentation/utils/grid_size_utils.dart';

/// Strategy interface for resolving a [TileSize] to its grid [GridDimension].
///
/// Implement this interface to add a new sizing context (e.g. tablet-specific)
/// without touching existing strategies or the layout algorithm.
///
/// Example:
/// ```dart
/// final TileSizingStrategy strategy = DesktopSizingStrategy();
/// final GridDimension dim = strategy.getDimensions(TileSize.fullsize);
/// ```
abstract interface class TileSizingStrategy {
  /// Returns the [GridDimension] (column span + row height) for a given [tileSize].
  GridDimension getDimensions(TileSize tileSize);
}
