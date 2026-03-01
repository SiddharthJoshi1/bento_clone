import '../entities/tile_config.dart';

abstract class TileRepository {
  List<TileConfig> getTiles();
}

class TileRepositoryImpl implements TileRepository {
  const TileRepositoryImpl(this._tiles);

  final List<TileConfig> _tiles;

  @override
  List<TileConfig> getTiles() => _tiles;
}
