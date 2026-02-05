import 'package:bento_clone/domain/entities/tile_config.dart';
import 'package:bento_clone/presentation/widgets/bento_grid/tiles/smart_bento_tile.dart';
import 'package:flutter/material.dart';

import 'layout/bento_grid_delegate.dart';

class BentoSliverList extends StatelessWidget {
  final List<TileConfig> tiles;

  const BentoSliverList({super.key, required this.tiles});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: 80)),

        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverGrid(
            // Pass your custom delegate here directly
            gridDelegate: BentoGridDelegate(tiles: tiles, context: context),
            delegate: SliverChildBuilderDelegate((context, index) {
              return Padding(
                padding: EdgeInsetsGeometry.all(10),
                child: SmartBentoTile(config: tiles[index]),
              );
            }, childCount: tiles.length),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}
