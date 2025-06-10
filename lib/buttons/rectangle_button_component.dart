import 'package:flame/events.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// A rectangular button component for a Flame game.
///
/// This component displays a button with a label and handles tap events.
/// It changes its background color when pressed and triggers the `onPressed` callback.
class RectangleButtonComponent extends PositionComponent
    with TapCallbacks, HasVisibility {
  /// Callback function to be executed when the button is pressed.
  void Function() onPressed;

  /// The label text displayed on the button.
  String label;

  /// The default background color of the button.
  Color color;

  /// The background color of the button when pressed.
  Color pressedColor;

  /// The color of the label text.
  Color textColor;

  /// The current background color of the button.
  late Color currentColor;

  /// The background rectangle of the button.
  late RectangleComponent background;

  /// The text component displaying the label.
  late TextComponent text;

  /// Creates a [RectangleButtonComponent].
  ///
  /// [onPressed] is the callback triggered when the button is pressed.
  /// [label] is the text displayed on the button.
  /// [size] and [position] define the size and position of the button.
  /// [color] is the default background color.
  /// [pressedColor] is the background color when pressed. Defaults to [color].
  /// [textColor] is the color of the label text.
  RectangleButtonComponent({
    required this.onPressed,
    required this.label,
    required super.size,
    required super.position,
    required this.color,
    Color? pressedColor,
    this.textColor = Colors.white,
  }) : pressedColor = pressedColor ?? color,
       currentColor = color;

  /// Loads the button's components (background and text).
  @override
  Future<void> onLoad() async {
    background = RectangleComponent(
      size: size,
      paint: Paint()..color = currentColor,
    );

    text = TextComponent(
      text: label,
      anchor: Anchor.center,
      position: size / 2,
      textRenderer: TextPaint(style: TextStyle(color: textColor, fontSize: 10)),
    );

    addAll([background, text]);
  }

  /// Handles the tap down event by changing the background color to [pressedColor].
  @override
  void onTapDown(TapDownEvent event) {
    background.paint.color = pressedColor;
  }

  /// Handles the tap up event by resetting the background color to [color]
  /// and triggering the [onPressed] callback.
  @override
  void onTapUp(TapUpEvent event) {
    background.paint.color = color;
    onPressed();
  }
}
