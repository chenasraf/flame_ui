import 'package:flame/components.dart';
import 'package:flame/events.dart';

class ScrollableAreaComponent extends PositionComponent
    with HasGameReference, DragCallbacks {
  final PositionComponent content;
  final double? contentHeight;
  final bool autoContentHeight;

  late final ClipComponent clip;
  double scrollOffset = 0.0;

  ScrollableAreaComponent({
    required this.content,
    required Vector2 size,
    required Vector2 position,
    this.contentHeight,
    this.autoContentHeight = true,
  }) : super(size: size, position: position);

  double get resolvedContentHeight =>
      contentHeight ?? (autoContentHeight ? content.size.y : size.y);

  double get viewportHeight => size.y;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    clip = ClipComponent.rectangle(size: size);
    add(clip);

    content.position = Vector2.zero();
    clip.add(content);
  }

  @override
  bool onDragUpdate(DragUpdateEvent event) {
    scrollOffset -= event.canvasDelta.y;

    final maxOffset = (resolvedContentHeight - viewportHeight).clamp(
      0.0,
      double.infinity,
    );
    scrollOffset = scrollOffset.clamp(0.0, maxOffset);

    content.position = Vector2(0, -scrollOffset);
    return true;
  }
}

