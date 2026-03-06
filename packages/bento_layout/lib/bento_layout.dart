/// bento_layout — skyline bin-packing grid for Flutter.
///
/// Public API:
///   - [BentoGrid]              — drop-in scrollable grid widget
///   - [BentoItem]              — tile wrapper (child + size)
///   - [BentoItemSize]          — 3×3 tile size enum
///   - [BentoDimension]         — resolved width fraction + height span
///   - [BentoSizingStrategy]    — interface for custom size mappings
///   - [DefaultBentoSizingStrategy] — built-in 3×3 size implementation
library;

export 'src/bento_grid.dart';
export 'src/bento_item.dart';
export 'src/bento_item_size.dart';
export 'src/bento_dimension.dart';
export 'src/bento_sizing_strategy.dart';
export 'src/layout/bento_grid_delegate.dart';
