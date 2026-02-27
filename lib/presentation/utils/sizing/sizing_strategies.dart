import 'package:bento_clone/domain/entities/tile_config.dart';
import 'package:bento_clone/presentation/utils/grid_size_utils.dart';

/// Desktop sizing strategy.
///
/// Tiles use their full declared size — fullsize, longVertical, etc. are all
/// rendered at their intended dimensions.
class DesktopSizingStrategy implements TileSizingStrategy {
  const DesktopSizingStrategy();

  @override
  GridDimension getDimensions(TileSize tileSize) {
    switch (tileSize) {
      case TileSize.fullsize:
        return GridDimension(width: 2, height: 2);
      case TileSize.standard:
        return GridDimension(width: 2, height: 1);
      case TileSize.small:
        return GridDimension(width: 1, height: 1);
      case TileSize.thin:
        return GridDimension(width: 2, height: 0.5);
      case TileSize.longVertical:
        return GridDimension(width: 1, height: 2);
      case TileSize.longHorizontal:
        return GridDimension(width: 4, height: 0.5);
    }
  }
}

/// Mobile sizing strategy.
///
/// All tiles are collapsed to a full-width bar or rectangle to suit a
/// single-column scrollable list on small screens.
class MobileSizingStrategy implements TileSizingStrategy {
  const MobileSizingStrategy();

  @override
  GridDimension getDimensions(TileSize tileSize) {
    switch (tileSize) {
      case TileSize.fullsize:
      case TileSize.standard:
      case TileSize.longVertical:
        return GridDimension(width: 2, height: 1);
      case TileSize.small:
      case TileSize.thin:
      case TileSize.longHorizontal:
        return GridDimension(width: 2, height: 0.5);
    }
  }
}
