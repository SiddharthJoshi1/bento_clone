import 'package:flutter/material.dart';

import '../../../../../domain/entities/tile_config.dart';
import '../../../../utils/app_styles.dart';

class SectionTitleRenderer extends StatelessWidget {
  final TileConfig config;

  const SectionTitleRenderer({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    // Section titles sit outside bento cards on the scaffold background,
    // so their text colour must follow the active theme.
    final Color textColour =
        Theme.of(context).colorScheme.onSurface;

    return Container(
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.only(left: AppInsets.m),
      child: Text(
        config.title,
        style: ResponsiveText.titleSmall(context)?.copyWith(
          fontWeight: FontWeight.w600,
          color: textColour,
        ),
      ),
    );
  }
}
