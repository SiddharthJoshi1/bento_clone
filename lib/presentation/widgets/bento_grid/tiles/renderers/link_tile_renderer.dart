import 'package:flutter/material.dart';

import '../../../../../core/injector.dart';
import '../../../../../domain/entities/tile_config.dart';
import '../../../../../domain/repos/link_repo.dart';
import '../../../../utils/app_styles.dart';
import '../../../../utils/colour_extension.dart';
import '../../../../utils/icon_mapping.dart';
import '../../../../utils/tile_constants.dart';
import '../../../../utils/url_extension.dart';

class LinkTileRenderer extends StatelessWidget {
  final TileConfig config;
  final Color backgroundColour;

  const LinkTileRenderer({
    super.key,
    required this.config,
    required this.backgroundColour,
  });

  @override
  Widget build(BuildContext context) {
    final Color textColour = backgroundColour.contrastingTextColour;

    switch (config.tileSize) {
      // Tall tiles — icon + title stacked vertically, image below
      case TileSize.fullTower:
      case TileSize.halfTower:
      case TileSize.quarterTower:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: TilePadding.standard,
              child: _buildHeader(context, textColour: textColour),
            ),
            const Spacer(),
            if (config.imagePath != null)
              Expanded(
                flex: 4,
                child: Card(
                  color: backgroundColour,
                  clipBehavior: Clip.hardEdge,
                  margin: TilePadding.imageCard,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.black12),
                    borderRadius: AppRadii.card,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: AspectRatio(
                      aspectRatio: TileImageSizing.squareAspectRatio,
                      child: Image.asset(config.imagePath!, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
          ],
        );

      // Card tiles — icon + title left, image right
      case TileSize.fullCard:
      case TileSize.halfCard:
      case TileSize.quarterCard:
        return Row(
          children: [
            Expanded(
              flex: 4,
              child: Padding(
                padding: TilePadding.compact,
                child: _buildHeader(context, textColour: textColour),
              ),
            ),
            if (config.imagePath != null)
              Expanded(
                flex: 4,
                child: Padding(
                  padding: TilePadding.imageCardRow,
                  child: Card(
                    color: backgroundColour,
                    clipBehavior: Clip.hardEdge,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.black12),
                      borderRadius: AppRadii.chip,
                    ),
                    child: AspectRatio(
                      aspectRatio: TileImageSizing.squareAspectRatio,
                      child: Image.asset(config.imagePath!, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
          ],
        );

      // Bar tiles — icon + title inline, arrow at end
      case TileSize.fullBar:
      case TileSize.halfBar:
      case TileSize.quarterBar:
        return Padding(
          padding: TilePadding.horizontalCompact,
          child: Row(
            children: [
              _buildHeader(
                context,
                textColour: textColour,
                showIconAndTitleSideBySide: true,
              ),
              const Spacer(),
              if (config.url != null)
                Icon(
                  Icons.arrow_outward,
                  size: AppIconSizes.s,
                  color: textColour,
                ),
            ],
          ),
        );
    }
  }

  Widget _buildHeader(
    BuildContext context, {
    required Color textColour,
    bool showIconAndTitleSideBySide = false,
  }) {
    final linkEntity = locator<LinkRepository>().getLinkData(config.url ?? "");
    const iconPadding = EdgeInsets.all(AppInsets.s);
    final captionColour = textColour.withValues(alpha: 0.55);

    if (showIconAndTitleSideBySide) {
      return Row(
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: AppRadii.chip),
            color: Colors.white,
            child: Padding(
              padding: iconPadding,
              child: Icon(
                LinkIconMapping.getIcon(linkEntity.linkIcon),
                color: linkEntity.brandColour.toColour(),
                size: AppIconSizes.m,
              ),
            ),
          ),
          TileSpacing.horizontalSmall,
          Wrap(
            children: [
              Text(
                config.title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: ResponsiveText.labelLarge(context)
                    ?.copyWith(fontWeight: FontWeight.bold, color: textColour),
              ),
            ],
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: AppRadii.chip),
          color: Colors.white,
          child: Padding(
            padding: iconPadding,
            child: Icon(
              LinkIconMapping.getIcon(linkEntity.linkIcon),
              color: linkEntity.brandColour.toColour(),
              size: AppIconSizes.m,
            ),
          ),
        ),
        TileSpacing.small,
        Wrap(
          children: [
            Text(
              config.title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: (Breakpoints.isNarrow(context)
                      ? ResponsiveText.labelSmall(context)
                      : ResponsiveText.labelMedium(context))
                  ?.copyWith(fontWeight: FontWeight.bold, color: textColour),
            ),
          ],
        ),
        if (!Breakpoints.isNarrow(context)) ...[
          TileSpacing.tiny,
          Text(
            config.url?.getBasePath() ?? "",
            style: ResponsiveText.caption(context)
                ?.copyWith(color: captionColour),
          ),
        ],
      ],
    );
  }
}
