import 'package:flutter/material.dart';

import '../../../../../domain/entities/tile_config.dart';
import '../../../../utils/app_styles.dart';
import '../../../../utils/colour_extension.dart';
import '../../../../utils/tile_constants.dart';

class TextTileRenderer extends StatelessWidget {
  final TileConfig config;

  const TextTileRenderer({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    final textColor = _backgroundColour.contrastingTextColour;

    if (config.tileSize == TileSize.thin) {
      return Padding(
        padding: TilePadding.horizontal,
        child: Row(
          children: [
            Text(
              config.title,
              overflow: TextOverflow.ellipsis,
              style: ResponsiveText.caption(
                context,
              )?.copyWith(fontWeight: FontWeight.w600, color: textColor),
            ),
            const Spacer(),
            if (config.url != null)
              Icon(
                Icons.arrow_outward_sharp,
                size: AppIconSizes.s,
                color: textColor,
              ),
          ],
        ),
      );
    }

    return Padding(
      padding: TilePadding.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.bubble_chart_outlined,
                size: AppIconSizes.l,
                color: textColor,
              ),
            ],
          ),
          const Spacer(),
          Text(
            config.title,
            overflow: TextOverflow.fade,
            style: _getTextStyle(context, textColor),
          ),
        ],
      ),
    );
  }

  TextStyle _getTextStyle(BuildContext context, Color textColor) {

    if (Breakpoints.isTablet(context)) {
      return ResponsiveText.titleMedium(context)!.copyWith(
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w600,
        color: textColor,
      );
    } else {
      return ResponsiveText.titleSmall(context)!.copyWith(
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w600,
        color: textColor,
        overflow: TextOverflow.ellipsis,
      );
    }
  }

  Color get _backgroundColour =>
      config.colour != null ? config.colour!.toColour() : Colors.white;
}
