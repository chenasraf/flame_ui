import 'dart:ui' show VoidCallback;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart' show TextStyle, Colors, EdgeInsets;

/// A component representing a single item in a list.
///
/// This component displays an optional icon, a title, an optional subtitle,
/// and an optional action component. It supports custom styling and spacing.
class ListItemComponent extends PositionComponent
    with HasGameReference, TapCallbacks {
  /// The title text of the list item.
  final String title;

  /// The optional subtitle text of the list item.
  final String? subtitle;

  /// The optional icon to display in the list item.
  final Sprite? icon;

  /// The optional action component to display on the right side of the list item.
  final PositionComponent? action;

  /// The padding around the content of the list item.
  final EdgeInsets padding;

  /// The spacing between elements (e.g., icon, text, action) in the list item.
  final double spacing;

  /// The text style for the title.
  final TextStyle titleStyle;

  /// The text style for the subtitle.
  final TextStyle subtitleStyle;

  /// The size of the icon. If null, it defaults to the height of the content.
  final Vector2? iconSize;

  /// The callback to invoke when the list item is tapped.
  final VoidCallback? onPressed;

  /// Creates a [ListItemComponent] with the given parameters.
  ///
  /// [title] is required and specifies the main text of the list item.
  /// [subtitle] is optional and specifies additional text below the title.
  /// [icon] is optional and specifies an icon to display on the left.
  /// [action] is optional and specifies a component to display on the right.
  /// [onPressed] is optional and specifies a callback for tap events.
  /// [padding] specifies the padding around the content (default is 2).
  /// [spacing] specifies the spacing between elements (default is 4).
  /// [titleStyle] specifies the text style for the title.
  /// [subtitleStyle] specifies the text style for the subtitle.
  /// [size] and [position] specify the size and position of the component.
  /// [iconSize] specifies the size of the icon (optional).
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

    // Add the icon if it exists.
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

    // Add the action component if it exists.
    double actionWidth = 0;
    if (action != null) {
      actionWidth = action!.size.x;
      action!
        ..size.y = contentHeight
        ..position = Vector2(size.x - padding.right - actionWidth, padding.top);
      add(action!);
    }

    // Calculate the width available for the text block.
    final textWidth = size.x - x - padding.right - actionWidth;

    final hasSubtitle = subtitle != null;
    final titleFontSize = titleStyle.fontSize ?? 10;
    final subtitleFontSize = subtitleStyle.fontSize ?? 8;

    // Add the title and subtitle (if present) as text components.
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
    // Invoke the callback when the list item is tapped.
    onPressed?.call();
  }
}
