import 'package:bento_clone/presentation/pages/home_page.dart';
import 'package:bento_clone/presentation/theme/app_theme.dart';
import 'package:bento_clone/presentation/widgets/profile_section.dart';
import 'package:flutter/material.dart';

import 'core/injector.dart';
import 'presentation/widgets/tile_section.dart';

void main() {
  setupLocator();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize GetIt
    return MaterialApp(
      title: 'Sid | Product Engineer',
      theme: AppTheme.light,
      home: HomePage(
        profileWidget: ProfileSection(),
        tileSectionWidget: TileSection(),
      ),
    );
  }
}
