# Bento Clone

A personal portfolio app built with Flutter that displays content in a bento grid layout — differently-sized rectangular tiles packed tightly together, resembling a Japanese bento box.

Inspired by the original bento.me (now acquired by Linktree), this project recreates the distinctive aesthetic using a custom [`bento_layout`](https://pub.dev/packages/bento_layout) package powered by the Skyline Bin Packing Algorithm. Read more about the approach in [Creating a Bento Layout in Flutter](https://builtbysid.substack.com/p/creating-a-bento-layout-in-flutter).

## Features

- **Bento grid layout** with 9 tile size variants combining width (quarter/half/full) and height (bar/card/tower)
- **Multiple tile types**: links, text, images, maps, and section titles
- **6 theme flavours** (Chalk, Dusk, Espresso, Forest, Rose, Slate) with light/dark mode, persisted locally
- **Responsive design** adapting across mobile, tablet, and desktop breakpoints
- **JSON-driven content** — update your portfolio without rebuilding the app
- **Analytics** via Lukehog (release mode only)

## Architecture

The project follows clean architecture with separation into domain, data, and presentation layers:

- **State management**: flutter_bloc (ThemeCubit)
- **Dependency injection**: get_it
- **Content**: loaded from JSON asset files at startup
- **Tile rendering**: factory-based `SmartBentoTile` delegating to specialised renderers

## Getting Started

```bash
flutter pub get
flutter run
```

Content is configured via `assets/data/content.json` (profile and tiles) and `assets/data/popular_links.json` (platform link styles).
