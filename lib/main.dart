import 'package:bento_clone/presentation/pages/home_page.dart';
import 'package:bento_clone/presentation/widgets/profile_section.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      theme: ThemeData(
        useMaterial3: true,
        textTheme:
            GoogleFonts.interTextTheme(), // or GoogleFonts.dmSansTextTheme()
        // This forces ALL cards to have that Bento roundness
        cardTheme: CardThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
      ),
      home: HomePage(
        profileWidget: ProfileSection(),
        tileSectionWidget: TileSection(),
      ),
    );
  }
}
