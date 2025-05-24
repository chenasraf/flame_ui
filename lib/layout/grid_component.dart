import 'package:flame/components.dart';

class GridComponent extends PositionComponent {
  final List<PositionComponent> childrenComponents;
  final Vector2 childSize;
  final Vector2 spacing;

  GridComponent({
    required this.childrenComponents,
    required this.childSize,
    Vector2? spacing,
    required Vector2 size,
    required Vector2 position,
  }) : spacing = spacing ?? Vector2.all(0),
       super(size: size, position: position);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final totalCellWidth = childSize.x + spacing.x;
    final totalCellHeight = childSize.y + spacing.y;

    final columns = (size.x / totalCellWidth).floor();

    for (int i = 0; i < childrenComponents.length; i++) {
      final child = childrenComponents[i];
      final col = i % columns;
      final row = i ~/ columns;

      child.position = Vector2(col * totalCellWidth, row * totalCellHeight);

      add(child);
    }
  }
}

