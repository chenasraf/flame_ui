import 'package:flame/components.dart';

class ListComponent extends PositionComponent {
  final List<PositionComponent> childrenComponents;
  final double childHeight;
  final double spacing;
  final double? _width;

  ListComponent({
    required this.childrenComponents,
    required this.childHeight,
    double? spacing,
    double? width,
    super.size,
    super.position,
  }) : spacing = spacing ?? 0,
       _width = width;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    size.x = _width ?? size.x;

    final totalHeight =
        childrenComponents.length * childHeight +
        (childrenComponents.length - 1) * spacing;
    size.y = totalHeight;

    for (int i = 0; i < childrenComponents.length; i++) {
      final child = childrenComponents[i];
      final y = i * (childHeight + spacing);

      child.position = Vector2(0, y);
      child.size = Vector2(size.x, childHeight);

      add(child);
    }
  }
}

