import 'package:lukehog_client/lukehog_client.dart';

import '../../domain/repos/analytics_repo.dart';

class LukehogAnalyticsRepository implements AnalyticsRepository {
  final LukehogClient _client;

  LukehogAnalyticsRepository(this._client);

  Future<void> _trackEvent(
    String eventName, {
    Map<String, dynamic>? parameters,
  }) async {
    await _client.capture(
      eventName,
      properties: parameters ?? {},
      timestamp: DateTime.now(),
    );
  }

  @override
  void trackError(String context) {
    _trackEvent("error_occurred", parameters: {"context": context});
  }

  @override
  void trackPortfolioOpened() {
    _trackEvent("portfolio_opened", parameters: {});
  }

  @override
  void trackTileTapped(String eventName) {
    _trackEvent(eventName, parameters: {});
  }
}
