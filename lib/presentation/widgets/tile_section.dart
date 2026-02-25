import 'package:bento_clone/domain/entities/tile_config.dart';
import 'package:flutter/material.dart';

import 'bento_grid/bento_sliver_list.dart';

List<TileConfig> baseTiles = [
  // Row 1
  TileConfig.sectionTitleConfig(
    title:
        "My pattern for building clear, testable, and scalable user journeys.",
  ),
  TileConfig(
    title: "Bubbles: Breaking Down Complex Journeys",
    url: "https://github.com/TinyBigLabs/bubbles_example",
    type: TileType.link,
    tileSize: TileSize.fullsize, // The Big Box
    imagePath: "assets/bubbles.png",
  ),
  TileConfig.sectionTitleConfig(title: "How I work."),
  TileConfig.textTileConfig(
    tileSize: TileSize.standard,
    title:
        "I believe the best products are built by teams who communicate with clarity and empathy. ",
    colour: "#f9aa3a",
  ),
  TileConfig.sectionTitleConfig(title: "Find me here."),

  TileConfig(
    title: "Keep up with my work here.",
    url: "https://www.linkedin.com/in/siddharth-joshi-/",
    type: TileType.link,
    tileSize: TileSize.standard, // The Big Box
    imagePath: "assets/1635723301936.jpg",
  ),
  TileConfig(
    title: "Get my CV.",
    url:
        "https://sidjoshi.notion.site/CV-31282118ee9080fe8e51e36781755b9d?pvs=143",
    type: TileType.link,
    tileSize: TileSize.small, // The small Box
  ),
  TileConfig.sectionTitleConfig(title: "Projects & Writing"),
  TileConfig(
    type: TileType.link,
    tileSize: TileSize.fullsize,
    title: "Sometimes I write stuff. Come check it out!",
    url: "https://www.substack.com/@builtbysid",
    imagePath: "assets/Sid Gen.png",
  ),
  TileConfig(
    type: TileType.link,
    tileSize: TileSize.fullsize,
    title: "Check out my Github.",
    url: "https://www.github.com/SiddharthJoshi1",
    imagePath: "assets/untitled_dragon_game.gif",
  ),
  TileConfig.sectionTitleConfig(title: "Fancy working with me?"),

  TileConfig.textTileConfig(
    title: "Let's Build Something Cool",
    tileSize: TileSize.thin,
    url: "mailto:sid@builtbysid.dev",
    colour: "#000000",
  ),
];

class TileSection extends StatelessWidget {
  const TileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: BentoSliverList(tiles: baseTiles));
  }
}
