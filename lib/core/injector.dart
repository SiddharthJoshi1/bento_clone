import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

import '../domain/entities/link.dart';
import '../domain/repos/link_repo.dart';

final locator = GetIt.instance;

/// Loads all dependencies. Must be awaited before [runApp].
///
/// Reads `assets/data/popular_links.json` once at startup, parses it into
/// a [Map<String, LinkConfig>], and passes it to [LinkRepositoryImpl] so
/// [getLinkData] can stay synchronous throughout the app.
Future<void> setupLocator() async {
  final String raw = await rootBundle.loadString(
    'assets/data/popular_links.json',
  );

  final Map<String, dynamic> json =
      jsonDecode(raw) as Map<String, dynamic>;

  final Map<String, LinkConfig> platforms = json.map(
    (key, value) => MapEntry(
      key,
      LinkConfig.fromJson(value as Map<String, dynamic>),
    ),
  );

  locator.registerLazySingleton<LinkRepository>(
    () => LinkRepositoryImpl(platforms),
  );
}
