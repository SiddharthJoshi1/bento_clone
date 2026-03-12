import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:lukehog_client/lukehog_client.dart';


import '../data/analytics/lukehog_analytics_repo.dart';
import '../domain/entities/link.dart';
import '../domain/entities/profile_data.dart';
import '../domain/entities/tile_config.dart';
import '../domain/repos/analytics_repo.dart';
import '../domain/repos/link_repo.dart';
import '../domain/repos/profile_repo.dart';
import '../domain/repos/tile_repo.dart';
import '../domain/usecases/track_error.dart';
import '../domain/usecases/track_portfolio_opened.dart';
import '../domain/usecases/track_tile_tapped.dart';
import 'constants.dart';

final locator = GetIt.instance;

/// Loads and registers all dependencies. Must be awaited before [runApp].
///
/// Reads two asset files concurrently:
///   - `assets/data/popular_links.json` → [LinkRepository]
///   - `assets/data/content.json`       → [ProfileRepository] + [TileRepository]
///
/// All repository [get] methods remain synchronous after startup.
Future<void> setupLocator() async {
  final results = await Future.wait([
    rootBundle.loadString('assets/data/popular_links.json'),
    rootBundle.loadString('assets/data/content.json'),
  ]);

  // --- popular_links.json → LinkRepository ---
  final Map<String, dynamic> linksJson =
      jsonDecode(results[0]) as Map<String, dynamic>;

  final Map<String, LinkConfig> platforms = linksJson.map(
    (key, value) => MapEntry(
      key,
      LinkConfig.fromJson(value as Map<String, dynamic>),
    ),
  );

  // --- content.json → ProfileRepository + TileRepository ---
  final Map<String, dynamic> contentJson =
      jsonDecode(results[1]) as Map<String, dynamic>;

  final ProfileData profile = ProfileData.fromJson(
    contentJson['profile'] as Map<String, dynamic>,
  );

  final List<TileConfig> tiles = (contentJson['tiles'] as List<dynamic>)
      .map((e) => TileConfig.fromJson(e as Map<String, dynamic>))
      .toList();

  // --- Register ---
  locator.registerLazySingleton<LinkRepository>(
    () => LinkRepositoryImpl(platforms),
  );
  locator.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(profile),
  );
  locator.registerLazySingleton<TileRepository>(
    () => TileRepositoryImpl(tiles),
  );

  // --- Analytics ---
  locator.registerLazySingleton<AnalyticsRepository>(
    () => LukehogAnalyticsRepository(
      LukehogClient(AnalyticsConstants.lukehogAppId),
    ),
  );
  locator.registerLazySingleton<TrackPortfolioOpened>(
    () => TrackPortfolioOpened(locator<AnalyticsRepository>()),
  );
  locator.registerLazySingleton<TrackTileTapped>(
    () => TrackTileTapped(locator<AnalyticsRepository>()),
  );
  locator.registerLazySingleton<TrackError>(
    () => TrackError(locator<AnalyticsRepository>()),
  );
}
