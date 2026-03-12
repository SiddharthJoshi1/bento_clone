import '../repos/analytics_repo.dart';

/// Tracks that the portfolio was opened (cold start).
class TrackPortfolioOpened {
  const TrackPortfolioOpened(this._repo);

  final AnalyticsRepository _repo;

  void call() => _repo.trackPortfolioOpened();
}
