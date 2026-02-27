import 'package:flutter/material.dart';

import '../../../../../core/responsive/breakpoints.dart';
import '../../../../../domain/entities/tile_config.dart';
import '../../../../utils/app_styles.dart';

class MapTileRenderer extends StatelessWidget {
  final TileConfig config;

  const MapTileRenderer({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(color: Colors.blue[100]),
        const Center(
          child: Icon(
            Icons.location_on,
            color: Colors.red,
            size: AppIconSizes.xl,
          ),
        ),
        Positioned(
          bottom: AppInsets.s,
          left: AppInsets.s,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppInsets.s,
              vertical: AppInsets.s / 2,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppInsets.s),
            ),
            child: Text(
              config.title,
              style: ResponsiveText.caption(
                context,
              )?.copyWith(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
