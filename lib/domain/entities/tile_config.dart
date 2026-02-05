import 'dart:core';

import 'package:flutter/material.dart';

enum TileSize { small, thin, standard, longHorizontal, longVertical, fullsize }

enum TileType { sectionTitle, map, link, image, video, text }

// class TileConfig {
//   final String? title;
//   final String? imagePath;
//   final String? url;
//   final TileSize tileSize;
//   final TileType type;

//   TileConfig({
//     this.title,
//     this.imagePath,
//     this.tileSize = TileSize.standard,
//     this.url,
//     required this.type,
//   });
// }

class TileConfig {
  final String title;
  final String? imagePath; // Asset path or Network URL
  final String? url;
  final String? colour;
  final TileSize tileSize;
  final TileType type;

  TileConfig({
    required this.type,
    required this.tileSize,
    required this.title,
    this.colour,
    this.imagePath,
    this.url,
  });

  static TileConfig linkTileConfig({
    required String url,
    String? imagePath,
    required TileSize tileSize,
    required String title,
  }) {
    return TileConfig(
      type: TileType.link,
      tileSize: tileSize,
      title: title,
      url: url,
    );
  }

  static TileConfig sectionTitleConfig({required String title}) {
    return TileConfig(
      type: TileType.sectionTitle,
      tileSize: TileSize.longHorizontal,
      title: title,
    );
  }

  static TileConfig textTileConfig({
    required String title,
    String? colour,
    String? url,
    required TileSize tileSize,
  }) {
    return TileConfig(
      type: TileType.text,
      tileSize: tileSize,
      title: title,
      url: url,
      colour: colour,
    );
  }

 TileConfig copyWith({
    String? title,
    String? imagePath,
    String? url,
    String? colour,
    TileSize? tileSize,
    TileType? type,
  }) {
    return TileConfig(
      type: type ?? this.type,
      tileSize: tileSize ?? this.tileSize,
      title: title ?? this.title,
      imagePath: imagePath ?? this.imagePath,
      url: url ?? this.url,
      colour: colour ?? this.colour,
    );
  }
}
