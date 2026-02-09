import 'package:bento_clone/domain/entities/tile_config.dart';

class GridDimension {
  final int width;
  final double height;

  GridDimension({required this.width, required this.height});
}

class GridSizeUtils {
  static GridDimension getDesktopGridDimensions(TileSize tilesize) {
    switch (tilesize) {
      case TileSize.fullsize: // 4x4
        return GridDimension(width: 2, height: 2);

      case TileSize.standard: // 4x2
        return GridDimension(width: 2, height: 1);

      case TileSize.small: // 2x2
        return GridDimension(width: 1, height: 1);

      case TileSize.thin: // 1x4
        return GridDimension(width: 2, height: 0.5);

      case TileSize.longVertical:
        return GridDimension(width: 1, height: 2);

      case TileSize.longHorizontal:
        return GridDimension(width: 4, height: 0.5);
    }
  }

  static GridDimension getMobileGridDimensions(TileSize tilesize) {
    switch (tilesize) {
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
