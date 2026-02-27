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

  const LinkTileRenderer({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    TileConfig tileConfig = config;

    if (!Breakpoints.isDesktop(context) &&
        config.tileSize == TileSize.fullsize) {
      tileConfig = config.copyWith(tileSize: TileSize.standard);
    }
    if (!Breakpoints.isDesktop(context) &&
        config.tileSize == TileSize.small) {
      tileConfig = config.copyWith(tileSize: TileSize.thin);
    }

    switch (tileConfig.tileSize) {
      case TileSize.fullsize:
      case TileSize.longVertical:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: TilePadding.standard,
              child: _buildHeader(context, showIcon: true),
            ),
            const Spacer(),
            if (config.imagePath != null)
              Expanded(
                flex: 4,
                child: Card(
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

      case TileSize.standard:
        return Row(
          children: [
            Expanded(
              flex: 4,
              child: Padding(
                padding: TilePadding.compact,
                child: _buildHeader(context, showIcon: true),
              ),
            ),
            if (config.imagePath != null)
              Expanded(
                flex: 4,
                child: Padding(
                  padding: TilePadding.imageCardRow,
                  child: Card(
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

      case TileSize.small:
        return Padding(
          padding: TilePadding.standard,
          child: _buildHeader(context, showIcon: true),
        );

      case TileSize.thin:
      case TileSize.longHorizontal:
        return Padding(
          padding: TilePadding.horizontalCompact,
          child: Row(
            children: [
              _buildHeader(context, showIconAndTitleSideBySide: true),
              const Spacer(),
              if (config.url != null)
                const Icon(
                  Icons.arrow_outward,
                  size: AppIconSizes.s,
                  color: Colors.grey,
                ),
            ],
          ),
        );
    }
  }

  Widget _buildHeader(
    BuildContext context, {
    bool showIcon = false,
    bool showIconAndTitleSideBySide = false,
  }) {
    final linkEntity = locator<LinkRepository>().getLinkData(config.url ?? "");
    const iconPadding = EdgeInsets.all(AppInsets.s);

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
                style: ResponsiveText.labelLarge(
                  context,
                )?.copyWith(fontWeight: FontWeight.bold),
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
            Breakpoints.isNarrow(context)
                ? Text(
                    config.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: ResponsiveText.labelSmall(
                      context,
                    )?.copyWith(fontWeight: FontWeight.bold),
                  )
                : Text(
                    config.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: ResponsiveText.labelMedium(
                      context,
                    )?.copyWith(fontWeight: FontWeight.bold),
                  ),
          ],
        ),
        if (!Breakpoints.isNarrow(context)) ...[
          TileSpacing.tiny,
          Text(
            config.url?.getBasePath() ?? "",
            style: ResponsiveText.caption(context),
          ),
        ],
      ],
    );
  }

}
