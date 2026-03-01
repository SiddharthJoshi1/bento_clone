import 'package:flutter/material.dart';

import '../../core/injector.dart';
import '../../domain/repos/tile_repo.dart';
import 'bento_grid/bento_sliver_list.dart';

class TileSection extends StatelessWidget {
  const TileSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tiles = locator<TileRepository>().getTiles();
    return Center(child: BentoSliverList(tiles: tiles));
  }
}
