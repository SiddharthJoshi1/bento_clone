import 'package:bento_clone/domain/entities/tile_config.dart';
import 'package:bento_clone/presentation/utils/sizing/sizing_strategies.dart';

export 'package:bento_clone/presentation/utils/sizing/tile_sizing_strategy.dart';
export 'package:bento_clone/presentation/utils/sizing/sizing_strategies.dart';

class GridDimension {
  final int width;
  final double height;

  GridDimension({required this.width, required this.height});
}

/// @deprecated Use [DesktopSizingStrategy] or [MobileSizingStrategy] directly.
/// Kept as a thin delegate so existing call sites compile without changes.
class GridSizeUtils {
  static const _desktop = DesktopSizingStrategy();
  static const _mobile = MobileSizingStrategy();

  static GridDimension getDesktopGridDimensions(TileSize tilesize) =>
      _desktop.getDimensions(tilesize);

  static GridDimension getMobileGridDimensions(TileSize tilesize) =>
      _mobile.getDimensions(tilesize);
}
