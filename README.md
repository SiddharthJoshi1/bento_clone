# Bento Clone

A personal portfolio app built with Flutter, displaying content in a bento grid layout — differently-sized rectangular tiles packed tightly together, resembling a Japanese bento box.

Inspired by bento.me, this project recreates the distinctive aesthetic using a custom [`bento_layout`](https://pub.dev/packages/bento_layout) package powered by the Skyline Bin Packing Algorithm. Read more in [Creating a Bento Layout in Flutter](https://builtbysid.substack.com/p/creating-a-bento-layout-in-flutter).

## Features

- **Bento grid layout** with 9 tile size variants combining width (quarter/half/full) and height (bar/card/tower)
- **Multiple tile types**: links, text, images, maps, and section titles
- **Remote JSON-driven content** — update the portfolio by pushing a new `content.json`, no rebuild required
- **Three-tier content cache**: in-memory → SharedPreferences → bundled asset fallback
- **6 theme flavours** (Chalk, Dusk, Espresso, Forest, Rose, Slate) with light/dark mode, persisted locally
- **Responsive design** across mobile, tablet, and desktop
- **Analytics** via Lukehog (release mode only, injected at build time)

## Architecture

Clean architecture with domain, data, and presentation layers.

**State management**
- `ThemeCubit` (Bloc) — brightness toggle and flavour switching, persisted via SharedPreferences
- `PortfolioBloc` — drives the app loading lifecycle: `loading → loaded / error`

**Content loading**
- On cold start, `PortfolioBloc` fires `LoadPortfolio`
- `RemoteConfigRepository` reads the best available JSON from `CacheManager` instantly, then attempts a remote fetch in the background
- If the remote `version` field is newer than the cached version, the cache is updated and the new content is used
- Failures at every tier fall through gracefully — the bundled `assets/data/content.json` is always the last resort

**Dependency injection**: GetIt

**Tile rendering**: factory-based `SmartBentoTile` delegating to specialised renderers per `TileType`

## Getting Started

```bash
flutter pub get
flutter run
```

Analytics requires a `LUKEHOG_APP_ID` environment variable injected at build time:

```bash
flutter run --dart-define=LUKEHOG_APP_ID=your_id
```

## Content

Portfolio content lives in `assets/data/content.json`. The app fetches a remote copy on startup and caches it — bump the `version` field to trigger a cache refresh on the next open.

Tile and profile structure is documented in the JSON schema comments in `lib/domain/entities/tile_config.dart` and `lib/domain/entities/profile_data.dart`.

## Related

- [`bento_layout`](https://pub.dev/packages/bento_layout) — the pub.dev package extracted from this project
- [Creating a Bento Layout in Flutter](https://builtbysid.substack.com/p/creating-a-bento-layout-in-flutter) — the accompanying write-up
