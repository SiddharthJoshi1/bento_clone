import 'package:flutter/material.dart';

import '../../../../../domain/entities/tile_config.dart';
import '../../../../utils/app_styles.dart';

class ImageTileRenderer extends StatelessWidget {
  final TileConfig config;

  const ImageTileRenderer({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (config.imagePath != null)
          Image.asset(config.imagePath!, fit: BoxFit.cover),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.imageGradientStart, AppColors.imageGradientEnd],
            ),
          ),
        ),
        Positioned(
          bottom: AppInsets.m,
          left: AppInsets.m,
          right: AppInsets.m,
          child: Text(
            config.title,
            style: ResponsiveText.titleSmall(
              context,
            )?.copyWith(color: AppColors.textOnDark, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
