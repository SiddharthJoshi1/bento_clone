/// The resolved dimensions of a bento tile.
///
/// [widthFraction] is a value between 0.0 (exclusive) and 1.0 (inclusive)
/// representing what proportion of the total grid width this tile occupies.
///
/// [heightSpan] is multiplied by [BentoGrid.unitHeight] to get pixel height.
class BentoDimension {
  const BentoDimension({
    required this.widthFraction,
    required this.heightSpan,
  }) : assert(
          widthFraction > 0.0 && widthFraction <= 1.0,
          'widthFraction must be between 0.0 (exclusive) and 1.0 (inclusive)',
        );

  /// Fraction of total grid width. 0.25 = quarter, 0.5 = half, 1.0 = full.
  final double widthFraction;

  /// Height in row units. Multiplied by unitHeight to get pixels.
  final double heightSpan;
}
