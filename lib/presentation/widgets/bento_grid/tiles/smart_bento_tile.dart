import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/injector.dart';
import '../../../../domain/entities/tile_config.dart';
import '../../../../domain/repos/link_repo.dart';
import '../../../utils/colour_extension.dart';
import '../../../utils/tile_constants.dart';
import 'mouse_hover_effect.dart';
import 'renderers/image_tile_renderer.dart';
import 'renderers/link_tile_renderer.dart';
import 'renderers/map_tile_renderer.dart';
import 'renderers/section_title_renderer.dart';
import 'renderers/text_tile_renderer.dart';

/// A factory widget that delegates rendering to the appropriate tile renderer
/// based on [TileConfig.type]. Each renderer is responsible for its own layout.
class SmartBentoTile extends StatelessWidget {
  final TileConfig config;

  const SmartBentoTile({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    final backgroundColour = _getBackgroundCardColour();
    return _buildBackgroundCard(_buildRenderer(context, backgroundColour), backgroundColour);
  }

  /// Delegates to the correct renderer based on tile type.
  Widget _buildRenderer(BuildContext context, Color backgroundColour) {
    switch (config.type) {
      case TileType.link:
        return LinkTileRenderer(config: config, backgroundColour: backgroundColour);
      case TileType.text:
        return TextTileRenderer(config: config);
      case TileType.image:
        return ImageTileRenderer(config: config);
      case TileType.sectionTitle:
        return SectionTitleRenderer(config: config);
      case TileType.map:
        return MapTileRenderer(config: config);
      default:
        return const Center(child: Text("Unknown Type"));
    }
  }

  Color _getBackgroundCardColour() {
    if (config.type == TileType.link) {
      final brandColour =
          locator<LinkRepository>().getLinkData(config.url ?? "").brandColour;
      return brandColour == "#000000" || brandColour == "#FFFFFF"
          ? Colors.white
          : locator<LinkRepository>()
                .getLinkData(config.url ?? "")
                .brandColour
                .toSuperLightColour();
    } else if (config.type == TileType.text) {
      return config.colour != null ? config.colour!.toColour() : Colors.white;
    } else {
      return Colors.transparent;
    }
  }

  Widget _buildBackgroundCard(Widget child, Color backgroundColour) {
    return BentoInteractionEffect(
      onTap: config.url != null
          ? () => launchUrl(
              Uri.parse(config.url!),
              mode: LaunchMode.externalApplication,
            )
          : null,
      child: Card(
        elevation: config.type == TileType.sectionTitle ? 0 : 2,
        clipBehavior: Clip.antiAlias,
        color: backgroundColour,
        child: InkWell(
          onTap: config.url != null
              ? () => launchUrl(Uri.parse(config.url!))
              : null,
          child: Padding(
            padding: TileType.link == config.type
                ? TilePadding.tiny
                : EdgeInsets.zero,
            child: child,
          ),
        ),
      ),
    );
  }
}
