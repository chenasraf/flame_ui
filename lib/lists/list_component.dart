import 'package:flame/components.dart';

/// A component that arranges its child components in a vertical list layout.
///
/// This component automatically positions its child components vertically
/// with a specified height for each child and optional spacing between them.
class ListComponent extends PositionComponent {
  /// The list of child components to be arranged in the vertical list.
  final List<PositionComponent> childrenComponents;

  /// The height of each child component in the list.
  final double childHeight;

  /// The spacing between child components in the list.
  /// Defaults to zero if not provided.
  final double spacing;

  /// The width of the list. If null, it will use the current width of the component.
  final double? _width;

  /// Creates a [ListComponent] with the given parameters.
  ///
  /// [children] is the list of child components to arrange.
  /// [childHeight] specifies the height of each child component.
  /// [spacing] specifies the spacing between child components (optional).
  /// [width] specifies the width of the list (optional).
  /// [size] specifies the size of the component.
  /// [position] specifies the position of the component.
  ListComponent({
    required List<PositionComponent> children,
    required this.childHeight,
    double? spacing,
    double? width,
    super.size,
    super.position,
  }) : spacing = spacing ?? 0,
       childrenComponents = children,
       _width = width;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Set the width of the list, using the provided width or the current size.
    size.x = _width ?? size.x;

    // Calculate the total height of the list, including spacing.
    final totalHeight =
        childrenComponents.length * childHeight +
        (childrenComponents.length - 1) * spacing;
    size.y = totalHeight;

    // Arrange each child component in the vertical list.
    for (int i = 0; i < childrenComponents.length; i++) {
      final child = childrenComponents[i];
      final y = i * (childHeight + spacing);

      // Set the position and size of the child component.
      child.position = Vector2(0, y);
      child.size = Vector2(size.x, childHeight);

      // Add the child component to the list.
      add(child);
    }
  }
}
