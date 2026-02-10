import 'package:bento_clone/presentation/utils/app_styles.dart';
import 'package:flutter/material.dart';
import '../../../../domain/entities/tile_config.dart';
import 'layout/bento_grid_delegate.dart';
import 'layout/utils/layout_utils.dart';
import 'tiles/smart_bento_tile.dart';

class BentoSliverList extends StatelessWidget {
  final List<TileConfig> tiles;

  const BentoSliverList({super.key, required this.tiles});

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = ScreenSizeUtils.isDesktop(context);

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
          SliverToBoxAdapter(
            child: CircleAvatar(
              radius: 100,
              backgroundColor: Colors.white,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset("assets/Sid Gen.png"),
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 50)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                "Sid",
                style: Theme.of(
                  context,
                ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 10)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                softWrap: true,
                "Product Engineer who builds high-quality, scalable applications. My goal is to create software people will love.",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final config = tiles[index];

                // 1. Map the config to a mobile-friendly version
                final mobileConfig = MobileConfigMapper.getMobileConfig(config);

                // // 2. Get the specific height for this tile type to prevent RenderFlex errors
                final double height = MobileConfigMapper.getMobileHeight(
                  mobileConfig.tileSize,
                );

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SizedBox(
                    height:
                        height, // FIX: Constrain height so Spacer() inside the tile works
                    child: SmartBentoTile(config: mobileConfig),
                  ),
                );
              }, childCount: tiles.length),
            ),
          ),
        ],
      ],
    );
  }
}
