import 'package:get_it/get_it.dart';

import '../domain/repos/link_repo.dart';

final locator = GetIt.instance;

void setupLocator() {
  // Register LinkRepository as a lazy singleton.
  // It will be instantiated the first time it is requested.
  locator.registerLazySingleton<LinkRepository>(() => LinkRepositoryImpl());
}
