import 'package:flutter/material.dart';

import '../../../../../core/responsive/breakpoints.dart';
import '../../../../../domain/entities/tile_config.dart';
import '../../../../utils/app_styles.dart';
import '../../../../utils/colour_extension.dart';

class SectionTitleRenderer extends StatelessWidget {
  final TileConfig config;

  const SectionTitleRenderer({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    final isDark = _backgroundColour.computeLuminance() < 0.5;

    return Container(
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.only(left: AppInsets.m),
      child: Text(
        config.title,
        style: ResponsiveText.titleSmall(context)?.copyWith(
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Color get _backgroundColour =>
      config.colour != null ? config.colour!.toColour() : Colors.white;
}
