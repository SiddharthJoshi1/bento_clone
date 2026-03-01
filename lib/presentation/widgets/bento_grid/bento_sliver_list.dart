import 'package:bento_clone/core/responsive/breakpoints.dart';
import 'package:flutter/material.dart';
import '../../../../domain/entities/tile_config.dart';
import '../profile_section.dart';
import 'layout/bento_grid_delegate.dart';
import 'layout/utils/mobile_tile_adapter.dart';
import 'tiles/smart_bento_tile.dart';

class BentoSliverList extends StatelessWidget {
  final List<TileConfig> tiles;

  const BentoSliverList({super.key, required this.tiles});

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Breakpoints.isDesktop(context);

    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: 20)),

        // --- DESKTOP VIEW (Grid) ---
        if (isDesktop) ...[
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: BentoGridDelegate(tiles: tiles, context: context),
              delegate: SliverChildBuilderDelegate((context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: SmartBentoTile(config: tiles[index]),
                );
              }, childCount: tiles.length),
            ),
          ),
        ]
        // --- MOBILE VIEW (List) ---
        else ...[
          const SliverToBoxAdapter(child: ProfileSection()),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final config = tiles[index];
          
              // 1. Map the config to a mobile-friendly version
              final mobileConfig = MobileTileAdapter.getMobileConfig(config);
          
              // 2. Get the specific height for this tile type to prevent RenderFlex errors
              final double height = MobileTileAdapter.getMobileHeight(
                mobileConfig.tileSize,
                context,
              );
          
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SizedBox(
                  height: height,
                  child: SmartBentoTile(config: mobileConfig),
                ),
              );
            }, childCount: tiles.length),
          ),
        ],
      ],
    );
  }
}
