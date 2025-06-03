import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';

/// A component that provides a scrollable area for its content.
///
/// This component allows for vertical scrolling of its child content
/// within a defined viewport size, and supports fling scrolling with
/// velocity and damping behavior.
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

  /// The current vertical velocity from a fling.
  double _scrollVelocity = 0.0;

  /// The amount of velocity reduction per second.
  double damping;

  /// A short buffer of recent drag deltas to calculate fling speed.
  final List<_DragSample> _dragSamples = [];

  /// Max time range (ms) for calculating fling speed.
  final Duration _sampleWindow = const Duration(milliseconds: 100);

  ScrollableAreaComponent({
    required this.content,
    required Vector2 size,
    required Vector2 position,
    this.contentHeight,
    this.autoContentHeight = true,
    this.damping = 500.0,
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
    final now = DateTime.now();
    _dragSamples.add(_DragSample(now, -event.canvasDelta.y));

    // Remove old samples
    _dragSamples.removeWhere(
      (sample) => now.difference(sample.time) > _sampleWindow,
    );

    _applyScroll(-event.canvasDelta.y);
    return true;
  }

  @override
  bool onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);

    final now = DateTime.now();
    _dragSamples.removeWhere(
      (sample) => now.difference(sample.time) > _sampleWindow,
    );

    if (_dragSamples.length >= 2) {
      final oldest = _dragSamples.first;
      final newest = _dragSamples.last;
      final dy = newest.offset - oldest.offset;
      final dt = newest.time.difference(oldest.time).inMilliseconds / 1000;
      if (dt > 0) {
        _scrollVelocity = dy / dt;
      }
    }

    _dragSamples.clear();
    return true;
  }

  void _applyScroll(double delta) {
    scrollOffset += delta;
    final maxOffset = max(resolvedContentHeight - viewportHeight, 0.0);
    scrollOffset = scrollOffset.clamp(0.0, maxOffset);
    content.position = Vector2(0, -scrollOffset);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_scrollVelocity.abs() > 1.0) {
      _applyScroll(-_scrollVelocity * dt);

      final sign = _scrollVelocity.sign;
      _scrollVelocity -= sign * damping * dt;

      if (_scrollVelocity.sign != sign) {
        _scrollVelocity = 0.0;
      }
    }
  }
}

class _DragSample {
  final DateTime time;
  final double offset;

  _DragSample(this.time, this.offset);
}
