import 'dart:ui' show VoidCallback;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart' show TextStyle, Colors, EdgeInsets;

class ListItemComponent extends PositionComponent
    with HasGameReference, TapCallbacks {
  final String title;
  final String? subtitle;
  final Sprite? icon;
  final PositionComponent? action;

  final EdgeInsets padding;
  final double spacing;

  final TextStyle titleStyle;
  final TextStyle subtitleStyle;
  final Vector2? iconSize;
  final VoidCallback? onPressed;

  ListItemComponent({
    required this.title,
    this.subtitle,
    this.icon,
    this.action,
    this.onPressed,
    this.padding = const EdgeInsets.all(2),
    this.spacing = 4,
    this.titleStyle = const TextStyle(fontSize: 10, color: Colors.white),
    this.subtitleStyle = const TextStyle(fontSize: 8, color: Colors.white70),
    super.size,
    super.position,
    this.iconSize,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final contentHeight = size.y - padding.vertical;
    double x = padding.left;

    // Icon
    if (icon != null) {
      final resolvedIconSize =
          iconSize ?? Vector2(contentHeight, contentHeight);
      final iconY = padding.top + (contentHeight - resolvedIconSize.y) / 2;

      final iconComponent = SpriteComponent(
        sprite: icon,
        position: Vector2(x, iconY),
        size: resolvedIconSize,
      );
      add(iconComponent);
      x += iconComponent.size.x + spacing;
    }

    // Action
    double actionWidth = 0;
    if (action != null) {
      actionWidth = action!.size.x;
      action!
        ..size.y = contentHeight
        ..position = Vector2(size.x - padding.right - actionWidth, padding.top);
      add(action!);
    }

    // Text block width
    final textWidth = size.x - x - padding.right - actionWidth;

    final hasSubtitle = subtitle != null;
    final titleFontSize = titleStyle.fontSize ?? 10;
    final subtitleFontSize = subtitleStyle.fontSize ?? 8;

    if (hasSubtitle) {
      final totalTextHeight = titleFontSize + spacing + subtitleFontSize;
      final startY = padding.top + (contentHeight - totalTextHeight) / 2;

      final titleText = TextComponent(
        text: title,
        anchor: Anchor.topLeft,
        textRenderer: TextPaint(style: titleStyle),
        position: Vector2(x, startY),
        size: Vector2(textWidth, 0), // 0 lets it size naturally
      );

      final subtitleText = TextComponent(
        text: subtitle!,
        anchor: Anchor.topLeft,
        textRenderer: TextPaint(style: subtitleStyle),
        position: Vector2(x, startY + titleFontSize + spacing),
        size: Vector2(textWidth, 0),
      );

      add(titleText);
      add(subtitleText);
    } else {
      final titleText = TextComponent(
        text: title,
        anchor: Anchor.topLeft,
        textRenderer: TextPaint(style: titleStyle),
        position: Vector2(x, padding.top + (contentHeight - titleFontSize) / 2),
        size: Vector2(textWidth, 0),
      );

      add(titleText);
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    onPressed?.call();
  }
}

