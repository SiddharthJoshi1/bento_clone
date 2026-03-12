import '../repos/analytics_repo.dart';

/// Tracks a link tile tap, encoding the tile title as a slug event name.
///
/// Slugification: lowercase, spaces → underscores, strips non-alphanumeric chars.
/// e.g. `'My GitHub!'` → `'tile_tapped_my_github'`
class TrackTileTapped {
  const TrackTileTapped(this._repo);

  final AnalyticsRepository _repo;

  void call(String tileTitle) {
    final slug = tileTitle
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
        .trim()
        .replaceAll(RegExp(r'\s+'), '_');
    _repo.trackTileTapped('tile_tapped_$slug');
  }
}
