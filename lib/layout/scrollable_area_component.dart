import 'package:flame/components.dart';
import 'package:flame/events.dart';

/// A component that provides a scrollable area for its content.
///
/// This component allows for vertical scrolling of its child content
/// within a defined viewport size.
class ScrollableAreaComponent extends PositionComponent
    with HasGameReference, DragCallbacks {
  /// The content to be displayed inside the scrollable area.
  final PositionComponent content;

  /// The height of the content. If null, it will be resolved based on
  /// [autoContentHeight].
  final double? contentHeight;

  /// Whether to automatically determine the content height based on
  /// the size of the content component.
  final bool autoContentHeight;

  /// A clipping component that ensures content outside the viewport
  /// is not visible.
  late final ClipComponent clip;

  /// The current vertical scroll offset.
  double scrollOffset = 0.0;

  /// Creates a [ScrollableAreaComponent].
  ///
  /// [content] is the child component to be displayed inside the scrollable area.
  /// [size] specifies the size of the viewport.
  /// [position] specifies the position of the scrollable area.
  /// [contentHeight] optionally specifies the height of the content.
  /// [autoContentHeight] determines if the content height should be
  /// automatically calculated (default is true).
  ScrollableAreaComponent({
    required this.content,
    required Vector2 size,
    required Vector2 position,
    this.contentHeight,
    this.autoContentHeight = true,
  }) : super(size: size, position: position);

  /// Resolves the height of the content based on [contentHeight] or
  /// [autoContentHeight].
  double get resolvedContentHeight =>
      contentHeight ?? (autoContentHeight ? content.size.y : size.y);

  /// The height of the viewport.
  double get viewportHeight => size.y;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Create a clipping component to restrict content visibility to the viewport.
    clip = ClipComponent.rectangle(size: size);
    add(clip);

    // Position the content at the top-left corner and add it to the clip.
    content.position = Vector2.zero();
    clip.add(content);
  }

  @override
  bool onDragUpdate(DragUpdateEvent event) {
    // Update the scroll offset based on the drag event's vertical delta.
    scrollOffset -= event.canvasDelta.y;

    // Calculate the maximum scroll offset to prevent scrolling beyond content.
    final maxOffset = (resolvedContentHeight - viewportHeight).clamp(
      0.0,
      double.infinity,
    );

    // Clamp the scroll offset within the valid range.
    scrollOffset = scrollOffset.clamp(0.0, maxOffset);

    // Update the content's position based on the scroll offset.
    content.position = Vector2(0, -scrollOffset);
    return true;
  }
}

