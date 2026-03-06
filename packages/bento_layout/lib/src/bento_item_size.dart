/// Tile size vocabulary for the bento grid.
///
/// Names encode both dimensions: prefix = width tier, suffix = shape.
///
/// Width tiers:
///   quarter = 0.25 of grid width
///   half    = 0.50 of grid width
///   full    = 1.00 of grid width
///
/// Shape suffixes:
///   Bar   = 0.5 units tall
///   Card  = 1.0 units tall
///   Tower = 2.0 units tall
///
/// | BentoItemSize | widthFraction | heightSpan |
/// |---------------|---------------|------------|
/// | quarterBar    | 0.25          | 0.5        |
/// | quarterCard   | 0.25          | 1.0        |
/// | quarterTower  | 0.25          | 2.0        |
/// | halfBar       | 0.5           | 0.5        |
/// | halfCard      | 0.5           | 1.0        |
/// | halfTower     | 0.5           | 2.0        |
/// | fullBar       | 1.0           | 0.5        |
/// | fullCard      | 1.0           | 1.0        |
/// | fullTower     | 1.0           | 2.0        |
enum BentoItemSize {
  quarterBar,
  quarterCard,
  quarterTower,
  halfBar,
  halfCard,
  halfTower,
  fullBar,
  fullCard,
  fullTower,
}
