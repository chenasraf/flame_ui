import 'package:flame/components.dart';

/// A component that arranges its child components in a grid layout.
class GridComponent extends PositionComponent {
  /// The list of child components to be arranged in the grid.
  final List<PositionComponent> childrenComponents;

  /// The size of each child component in the grid.
  final Vector2 childSize;

  /// The spacing between child components in the grid.
  /// Defaults to zero if not provided.
  final Vector2 spacing;

  /// Creates a [GridComponent] with the given parameters.
  ///
  /// [children] is the list of child components to arrange.
  /// [childSize] specifies the size of each child component.
  /// [spacing] specifies the spacing between child components (optional).
  /// [size] specifies the size of the grid.
  /// [position] specifies the position of the grid.
  GridComponent({
    required List<PositionComponent> children,
    required this.childSize,
    Vector2? spacing,
    required Vector2 size,
    required Vector2 position,
  }) : spacing = spacing ?? Vector2.all(0),
       childrenComponents = children,
       super(size: size, position: position);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Calculate the total width and height of each cell, including spacing.
    final totalCellWidth = childSize.x + spacing.x;
    final totalCellHeight = childSize.y + spacing.y;

    // Determine the number of columns that can fit in the grid.
    final columns = (size.x / totalCellWidth).floor();

    // Arrange each child component in the grid.
    for (int i = 0; i < childrenComponents.length; i++) {
      final child = childrenComponents[i];
      final col = i % columns; // Column index
      final row = i ~/ columns; // Row index

      // Set the position of the child component.
      child.position = Vector2(col * totalCellWidth, row * totalCellHeight);

      // Add the child component to the grid.
      add(child);
    }
  }
}

