import 'dart:ui';

import 'package:bento_clone/core/theme/theme_cubit.dart';
import 'package:bento_clone/core/theme/theme_state.dart';
import 'package:bento_clone/presentation/pages/home_page.dart';
import 'package:bento_clone/presentation/theme/app_theme.dart';
import 'package:bento_clone/presentation/widgets/profile_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/injector.dart';
import 'domain/usecases/track_error.dart';
import 'domain/usecases/track_portfolio_opened.dart';
import 'presentation/widgets/tile_section.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();

  // --- Analytics: cold start ---
  locator<TrackPortfolioOpened>().call();

  // --- Analytics: error hooks ---
  final trackError = locator<TrackError>();

  FlutterError.onError = (details) {
    FlutterError.presentError(details); // preserve default behaviour
    trackError.call('flutter_error');
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    trackError.call('platform_error');
    return false; // false = don't swallow the error
  };

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Sid | Product Engineer',
            theme: AppTheme.light(state.flavour.light),
            darkTheme: AppTheme.dark(state.flavour.dark),
            themeMode: state.mode,
            home: HomePage(
              profileWidget: const ProfileSection(),
              tileSectionWidget: const TileSection(),
            ),
          );
        },
      ),
    );
  }
}
