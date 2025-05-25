import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart' show Colors, TextStyle, EdgeInsets;
import 'package:flutter/painting.dart';

import '../layout/scrollable_area_component.dart';

/// A modal dialog component that can display content, a title, a footer, and a close button.
///
/// This component is designed to be used in a Flame game and provides a scrollable
/// area for its content, along with customizable styling and behavior.
class ModalComponent extends PositionComponent with HasGameReference {
  /// The content to be displayed inside the scrollable area of the modal.
  final PositionComponent scrollContent;

  /// The optional title of the modal.
  final String? title;

  /// The padding around the content of the modal.
  final EdgeInsets padding;

  /// The height of the content. If null, it will be resolved based on [autoContentHeight].
  final double? contentHeight;

  /// Whether to automatically determine the content height based on the size of the content.
  final bool autoContentHeight;

  /// The text style for the title.
  final TextStyle? titleStyle;

  /// The spacing between the title and the content.
  final double titleSpacing;

  /// The paint used to draw the background of the modal.
  final Paint dialogPaint;

  /// The optional close button to be rendered in the top-right corner.
  ///
  /// The button will be automatically positioned based on [padding] and its own size.
  /// Any [PositionComponent] can be used, including [SpriteButtonComponent].
  final PositionComponent? closeButton;

  /// The callback to invoke when the modal is closed.
  ///
  /// This is not wired to [closeButton] directly — you should attach it to the component manually.
  final VoidCallback? onClose;

  /// The callback to invoke after the modal has finished loading.
  final VoidCallback? onAfterLoad;

  /// The optional footer component to display at the bottom of the modal.
  final PositionComponent? footer;

  /// The default height of the footer if its size is not explicitly set.
  final double defaultFooterHeight;

  /// The scrollable area component for the modal's content.
  late final ScrollableAreaComponent scrollArea;

  /// The background rectangle component for the modal.
  late final RectangleComponent background;

  /// The text component for the title, if a title is provided.
  late final TextComponent? titleComponent;

  /// Creates a [ModalComponent] with the given parameters.
  ///
  /// [scrollContent] is required and specifies the content to display inside the modal.
  /// [size] specifies the size of the modal.
  /// [position] specifies the position of the modal.
  /// [title] is optional and specifies the title of the modal.
  /// [padding] specifies the padding around the content (default is 8).
  /// [contentHeight] optionally specifies the height of the content.
  /// [autoContentHeight] determines if the content height should be automatically calculated (default is true).
  /// [titleStyle] specifies the text style for the title.
  /// [titleSpacing] specifies the spacing between the title and the content (default is 2).
  /// [paint] optionally specifies the paint for the background.
  /// [closeButton] optionally provides a component to render in the top-right corner.
  /// [onClose] optionally specifies a callback to call when the modal is closed.
  /// [onAfterLoad] optionally specifies a callback after the modal has loaded.
  /// [footer] optionally specifies a footer component to display at the bottom.
  /// [defaultFooterHeight] specifies the default height of the footer (default is 32).
  ModalComponent({
    required this.scrollContent,
    required Vector2 size,
    required Vector2 position,
    this.title,
    this.padding = const EdgeInsets.all(8),
    this.contentHeight,
    this.autoContentHeight = true,
    this.titleStyle,
    this.titleSpacing = 2,
    Paint? paint,
    this.closeButton,
    this.onClose,
    this.onAfterLoad,
    this.footer,
    this.defaultFooterHeight = 32,
  }) : dialogPaint = paint ?? (Paint()..color = Colors.black87),
       super(size: size, position: position);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Add the background rectangle.
    background = RectangleComponent(size: size, paint: dialogPaint);
    add(background);

    double scrollTop = padding.top;

    // Add the title if it exists.
    if (title != null) {
      titleComponent = TextComponent(
        text: title!,
        anchor: Anchor.topLeft,
        position: Vector2(padding.left, scrollTop),
        textRenderer: TextPaint(
          style:
              titleStyle ??
              const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
      );
      add(titleComponent!);
    }

    // Add the close button if it exists, positioned top-right using padding.
    if (closeButton != null) {
      await closeButton!.onLoad();
      closeButton!
        ..position = Vector2(
          size.x - padding.right - closeButton!.size.x,
          padding.top,
        )
        ..anchor = Anchor.topLeft;
      add(closeButton!);
    }

    // Adjust the scrollTop position below the title row.
    if (titleComponent != null) {
      await titleComponent!.onLoad();
      scrollTop += titleComponent!.height + titleSpacing;
    }

    // Add the footer if it exists.
    double scrollBottom = padding.bottom;
    if (footer != null) {
      await footer!.onLoad();
      add(footer!);
      final footerHeight =
          footer!.size.y > 0 ? footer!.size.y : defaultFooterHeight;
      scrollBottom += footerHeight + titleSpacing;
      footer!.position = Vector2(
        padding.left,
        size.y - scrollBottom + titleSpacing,
      );
    }

    // Create and add the scrollable area for the content.
    final scrollAreaSize = Vector2(
      size.x - padding.horizontal,
      size.y - scrollTop - scrollBottom,
    );

    scrollArea = ScrollableAreaComponent(
      content: scrollContent,
      size: scrollAreaSize,
      position: Vector2(padding.left, scrollTop),
      contentHeight: contentHeight,
      autoContentHeight: autoContentHeight,
    );
    add(scrollArea);

    // Invoke the callback after the modal has loaded.
    onAfterLoad?.call();
  }

  /// Displays the modal by adding it to the game's viewport.
  Future<void> show(FlameGame game) async {
    game.camera.viewport.add(this);
  }

  /// Hides the modal by removing it from the game's viewport.
  void hide(FlameGame game) {
    game.camera.viewport.remove(this);
  }
}
