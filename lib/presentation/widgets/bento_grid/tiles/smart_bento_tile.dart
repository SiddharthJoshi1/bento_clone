import 'package:bento_clone/presentation/utils/sizing_utils.dart';
import 'package:bento_clone/presentation/utils/url_extension.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/injector.dart';
import '../../../../domain/entities/tile_config.dart';
import '../../../../domain/repos/link_repo.dart';
import '../../../utils/colour_extension.dart';
import '../../../utils/icon_mapping.dart';
import 'mouse_hover_effect.dart';

class SmartBentoTile extends StatelessWidget {
  final TileConfig config;

  const SmartBentoTile({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    // 1. Base Container Styling (The "Matte Pop" Look)
    return getBackgroundCard(_buildContent(context));
  }

  // --- CONTENT BUILDER FACTORY ---
  Widget _buildContent(BuildContext context) {
    switch (config.type) {
      case TileType.image:
        return _buildImageFill(); // Rule: "Fills to the size of the box"
      case TileType.link:
        return _buildLinkLayout(context); // Complex Logic
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

  // 1. LINK LOGIC (The complex part)
  Widget _buildLinkLayout(BuildContext context) {
    TileConfig tileConfig = config;
    if (!SizingUtils.isDesktop(context) &&
        config.tileSize == TileSize.fullsize) {
      tileConfig = config.copyWith(tileSize: TileSize.standard);
    }
    if (!SizingUtils.isDesktop(context) && config.tileSize == TileSize.small) {
      tileConfig = config.copyWith(tileSize: TileSize.thin);
    }
    switch (tileConfig.tileSize) {
      // "If FullSize then it has an image at the bottom"
      // "If LongVertical then it gives us just the same as fullsize but thinner"
      case TileSize.fullsize:
      case TileSize.longVertical:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: _buildHeader(context, showIcon: true),
            ),
            const Spacer(),
            if (config.imagePath != null)
              Expanded(
                flex: 4,
                child: Card(
                  clipBehavior: Clip.hardEdge,
                  margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  elevation: 0,
                  color: getBackgroundCardColour(),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black12),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Image.network(
                    config.imagePath!,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
          ],
        );

      // "If Standard then it has an image on the right"
      case TileSize.standard:
        return Row(
          children: [
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: _buildHeader(context, showIcon: true),
              ),
            ),
            if (config.imagePath != null)
              Expanded(
                flex: 6,
                child: Padding(
                  padding: EdgeInsetsGeometry.only(
                    right: 15,
                    left: 0,
                    top: 20,
                    bottom: 20,
                  ),
                  child: Card(
                    clipBehavior: Clip.hardEdge,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black12),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Center(
                      child: Image.network(
                        height: 600,
                        width: 400,
                        config.imagePath!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );

      // "If Small then just Icon title and link"
      case TileSize.small:
        return Padding(
          padding: const EdgeInsets.all(20),
          child: _buildHeader(context, showIcon: true),
        );

      // "If Thin then it just has the title and the icon"
      case TileSize.thin:
      case TileSize.longHorizontal:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              _buildHeader(context, showIconAndTitleSideBySide: true),
              const Spacer(),
              if (config.url != null)
                const Icon(Icons.arrow_outward, size: 16, color: Colors.grey),
            ],
          ),
        );
    }
  }

  // 2. IMAGE LOGIC
  Widget _buildImageFill() {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (config.imagePath != null)
          Image.network(config.imagePath!, fit: BoxFit.cover),
        // Gradient overlay to make text readable
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
          bottom: 16,
          left: 16,
          right: 16,
          child: Text(
            config.title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // 3. TEXT LOGIC
  Widget _buildTextLayout(BuildContext context) {
    if (config.tileSize == TileSize.thin) {
      return
      // "Text is clipped" handled by overflow
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.starts,
          children: [
            Text(
              config.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: getBackgroundCardColour().computeLuminance() > 0.5
                    ? Colors.black
                    : Colors.white,
              ),
              overflow:
                  TextOverflow.ellipsis, // Fades out at bottom if too long
            ),
            Spacer(),
            if (config.url != null)
              SizedBox(
                child: IconButton.outlined(
                  color: Colors.white,
                  onPressed: () {},
                  icon: Icon(Icons.arrow_outward_sharp),
                ),
              ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "If it's a text with URL then the icon is on the right and is clickable"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Icon(Icons.format_quote_outlined, size: 28)],
          ),
          const SizedBox(height: 16),
          // "Text is clipped" handled by overflow
          Expanded(
            child: Text(
              config.title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              overflow: TextOverflow.fade, // Fades out at bottom if too long
            ),
          ),
        ],
      ),
    );
  }

  // 4. SECTION TITLE LOGIC
  Widget _buildSectionTitle(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        config.title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,

          color: getBackgroundCardColour().computeLuminance() < 0.5
              ? Colors.black
              : Colors.white,
        ),
      ),
    );
  }

  // 5. MAP LOGIC
  Widget _buildMapLayout(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Placeholder for real map
        Container(color: Colors.blue[100]),
        Center(child: Icon(Icons.location_on, color: Colors.red, size: 40)),
        Positioned(
          bottom: 12,
          left: 12,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              config.title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
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
    if (showIconAndTitleSideBySide) {
      return Row(
        children: [
          Card(
            // margin: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.all(Radius.circular(10)),
            ),
            color: Colors.white,
            child: Padding(
              padding: EdgeInsetsGeometry.all(10),
              child: Icon(
                color: linkEntity.brandColour.toColour(),
                size: 20,
                LinkIconMapping.getIcon(linkEntity.linkIcon),
              ),
            ),
          ),
          const SizedBox(width: 10),

          Text(
            config.title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.all(Radius.circular(10)),
          ),
          color: Colors.white,
          child: Padding(
            padding: EdgeInsetsGeometry.all(10),
            child: Icon(
              color: linkEntity.brandColour.toColour(),
              size: 25,
              LinkIconMapping.getIcon(linkEntity.linkIcon),
            ),
          ),
        ),
        const SizedBox(height: 10),

        Text(
          config.title,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 2),
        Text(
          config.url?.getBasePath() ?? "",
          style: Theme.of(context).textTheme.labelLarge,
        ),
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
      // Web Optimization: force open in new tab
      onTap: config.url != null
          ? () => launchUrl(
              Uri.parse(config.url!),
              mode: LaunchMode.externalApplication,
            )
          : null,
      child: Card(
        elevation: (config.type == TileType.sectionTitle) ? 0 : 2,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          // side: BorderSide(color: Colors.black12),
          borderRadius: BorderRadius.circular(24),
        ),
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
