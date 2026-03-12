import '../repos/analytics_repo.dart';

/// Tracks an unhandled error or crash.
///
/// [context] should be a short identifier e.g. `'flutter_error'`
/// or `'platform_error'`. Stack traces are not captured here —
/// Lukehog only counts events. Layer Sentry on top if traces are needed.
class TrackError {
  const TrackError(this._repo);

  final AnalyticsRepository _repo;

  void call(String context) => _repo.trackError(context);
}
