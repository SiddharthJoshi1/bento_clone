import 'package:bento_clone/presentation/utils/url_extension.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/injector.dart';
import '../../../../domain/entities/tile_config.dart';
import '../../../../domain/repos/link_repo.dart';
import '../../../utils/colour_extension.dart';
import '../../../utils/icon_mapping.dart';
import '../../../utils/app_styles.dart';
import 'mouse_hover_effect.dart';

class SmartBentoTile extends StatelessWidget {
  final TileConfig config;

  const SmartBentoTile({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return getBackgroundCard(_buildContent(context));
  }

  // --- CONTENT BUILDER FACTORY ---
  Widget _buildContent(BuildContext context) {
    switch (config.type) {
      case TileType.image:
        return _buildImageFill(context);
      case TileType.link:
        return _buildLinkLayout(context);
      case TileType.sectionTitle:
        return _buildSectionTitle(context);
      case TileType.text:
        return _buildTextLayout(context);
      case TileType.map:
        return _buildMapLayout(context);
      default:
        return const Center(child: Text("Unknown Type"));
    }
  }

  // --- LAYOUT LOGIC IMPLEMENTATIONS ---

  // 1. LINK LOGIC
  Widget _buildLinkLayout(BuildContext context) {
    final bool isTablet = ScreenSizeUtils.isTablet(context);
    TileConfig tileConfig = config;
    if (!ScreenSizeUtils.isDesktop(context) &&
        config.tileSize == TileSize.fullsize) {
      tileConfig = config.copyWith(tileSize: TileSize.standard);
    }
    if (!ScreenSizeUtils.isDesktop(context) &&
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
              padding: const EdgeInsets.all(AppInsets.l),
              child: _buildHeader(context, showIcon: true),
            ),
            const Spacer(),
            if (config.imagePath != null)
              Expanded(
                flex: 4,
                child: Card(
                  clipBehavior: Clip.hardEdge,
                  margin: const EdgeInsets.fromLTRB(
                    AppInsets.l,
                    0,
                    AppInsets.l,
                    AppInsets.l,
                  ),
                  elevation: 0,
                  color: getBackgroundCardColour(),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.black12),
                    borderRadius: AppRadii.card,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
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
              flex: 5,
              child: Padding(
                padding: EdgeInsets.all(isTablet ? AppInsets.s : AppInsets.l),
                child: _buildHeader(context, showIcon: true),
              ),
            ),
            if (config.imagePath != null)
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: AppInsets.m,
                    top: AppInsets.l,
                    bottom: AppInsets.l,
                  ),
                  child: Card(
                    clipBehavior: Clip.hardEdge,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.black12),
                      borderRadius: AppRadii.card,
                    ),
                    child: AspectRatio(
                      aspectRatio: 3 / 4,
                      child: Image.asset(config.imagePath!, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
          ],
        );

      case TileSize.small:
        return Padding(
          padding: const EdgeInsets.all(AppInsets.l),
          child: _buildHeader(context, showIcon: true),
        );

      case TileSize.thin:
      case TileSize.longHorizontal:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppInsets.l),
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

  // 2. IMAGE LOGIC
  Widget _buildImageFill(BuildContext context) {
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
              colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
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
            )?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  TextStyle getTextStyleForTextLayout(BuildContext context) {
    final bool isDark = getBackgroundCardColour().computeLuminance() < 0.5;
    Color textColor = isDark ? Colors.white : Colors.black;
    if (ScreenSizeUtils.isDesktop(context)) {
      return ResponsiveText.titleSmall(context)!.copyWith(
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w600,
        color: textColor,
      );
    } else {
      return ResponsiveText.titleSmall(context)!.copyWith(
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w300,
        color: textColor,
      );
    }
  }

  // 3. TEXT LOGIC
  Widget _buildTextLayout(BuildContext context) {
    final isDark = getBackgroundCardColour().computeLuminance() < 0.5;

    final textColor = isDark ? Colors.white : Colors.black;

    if (config.tileSize == TileSize.thin) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppInsets.xl),
        child: Row(
          children: [
            Text(
              config.title,
              style: ResponsiveText.caption(
                context,
              )?.copyWith(fontWeight: FontWeight.w600, color: textColor),

              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            if (config.url != null)
              Icon(
                Icons.arrow_outward_sharp,
                size: AppIconSizes.s,
                color: isDark ? Colors.white : Colors.black,
              ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppInsets.xl,
        vertical: AppInsets.m,
      ),
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
          Spacer(),
          Text(
            config.title,
            style: getTextStyleForTextLayout(context),
            overflow: TextOverflow.fade,
          ),
        ],
      ),
    );
  }

  // 4. SECTION TITLE LOGIC
  Widget _buildSectionTitle(BuildContext context) {
    final isDark = getBackgroundCardColour().computeLuminance() > 0.5;
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

  // 5. MAP LOGIC
  Widget _buildMapLayout(BuildContext context) {
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

  // --- HELPERS ---

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
          const SizedBox(width: AppInsets.s),
          Text(
            overflow: TextOverflow.ellipsis,
            config.title,
            style: ScreenSizeUtils.isNarrow(context)
                ? ResponsiveText.labelLarge(
                    context,
                  )?.copyWith(fontWeight: FontWeight.bold)
                : ResponsiveText.titleSmall(
                    context,
                  )?.copyWith(fontWeight: FontWeight.bold),
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
        const SizedBox(height: AppInsets.s),
        Text(
          // overflow: TextOverflow.ellipsis,
          config.title,
          style: ScreenSizeUtils.isNarrow(context)
              ? ResponsiveText.labelLarge(
                  context,
                )?.copyWith(fontWeight: FontWeight.bold)
              : ResponsiveText.titleSmall(
                  context,
                )?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (!ScreenSizeUtils.isNarrow(context)) ...[
          const SizedBox(height: 2),
          Text(
            config.url?.getBasePath() ?? "",
            style: ResponsiveText.caption(context),
          ),
        ],
      ],
    );
  }

  Color getBackgroundCardColour() {
    if (config.type == TileType.link) {
      return locator<LinkRepository>()
          .getLinkData(config.url ?? "")
          .brandColour
          .toSuperLightColour();
    } else if (config.type == TileType.text) {
      return config.colour != null ? config.colour!.toColour() : Colors.white;
    } else {
      return Colors.transparent;
    }
  }

  Widget getBackgroundCard(Widget child) {
    return BentoInteractionEffect(
      onTap: config.url != null
          ? () => launchUrl(
              Uri.parse(config.url!),
              mode: LaunchMode.externalApplication,
            )
          : null,
      child: Card(
        elevation: (config.type == TileType.sectionTitle) ? 0 : 2,
        clipBehavior: Clip.antiAlias,
        shape: config.type != TileType.sectionTitle
            ? RoundedRectangleBorder(borderRadius: AppRadii.card)
            : null,
        color: getBackgroundCardColour(),
        child: InkWell(
          onTap: config.url != null
              ? () => launchUrl(Uri.parse(config.url!))
              : null,
          child: child,
        ),
      ),
    );
  }
}
