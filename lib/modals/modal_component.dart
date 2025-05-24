import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart' show Colors, TextStyle, EdgeInsets;
import 'package:flutter/painting.dart';

import '../layout/scrollable_area_component.dart';

class ModalComponent extends PositionComponent with HasGameReference {
  final PositionComponent scrollContent;
  final String? title;
  final EdgeInsets padding;
  final double? contentHeight;
  final bool autoContentHeight;
  final TextStyle? titleStyle;
  final double titleSpacing;
  final Paint dialogPaint;
  final Sprite? closeIcon;
  final VoidCallback? onClose;
  final VoidCallback? onAfterLoad;
  final PositionComponent? footer;
  final double defaultFooterHeight;

  late final ScrollableAreaComponent scrollArea;
  late final RectangleComponent background;
  late final TextComponent? titleComponent;
  late final SpriteButtonComponent? closeButton;

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
    this.closeIcon,
    this.onClose,
    this.onAfterLoad,
    this.footer,
    this.defaultFooterHeight = 32,
  }) : dialogPaint =
           paint ?? Paint()
             ..color = Colors.black87,
       super(size: size, position: position);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(RectangleComponent(size: size, paint: dialogPaint));

    double scrollTop = padding.top;

    // Title
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

    // Close button
    if (closeIcon != null || onClose != null) {
      Sprite? effectiveCloseIcon = closeIcon;
      if (effectiveCloseIcon == null) {
        final iconSheet = SpriteSheet(
          image: await game.images.load('ui/ui_icons.png'),
          srcSize: Vector2.all(16),
        );
        effectiveCloseIcon = iconSheet.getSpriteById(3);
      }
      closeButton = SpriteButtonComponent(
        button: effectiveCloseIcon,
        buttonDown: effectiveCloseIcon,
        size: Vector2.all(16),
        position: Vector2(size.x - padding.right - 16, scrollTop),
        onPressed: onClose ?? () => removeFromParent(),
      );
      add(closeButton!);
    }

    // Advance scrollTop below title row
    if (titleComponent != null) {
      await titleComponent!.onLoad();
      scrollTop += titleComponent!.height + titleSpacing;
    }

    // Footer
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

    // Scrollable area
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

    onAfterLoad?.call();
  }

  Future<void> show(FlameGame game) async {
    game.camera.viewport.add(this);
  }

  void hide(FlameGame game) {
    game.camera.viewport.remove(this);
  }
}

