import 'package:flame/events.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// A circular button component for a Flame game.
///
/// This component displays a button with a label and handles tap events.
/// It changes its background color when pressed and triggers the `onPressed` callback.
class CircleButtonComponent extends PositionComponent
    with TapCallbacks, HasVisibility {
  /// Callback function to be executed when the button is pressed.
  void Function() onPressed;

  String? _label;

  /// The label text displayed on the button.
  String? get label => _label;
  set label(String? value) {
    _label = value;
    if (label != null && label!.isNotEmpty) {
      if (_text == null) {
        _text = TextComponent(
          text: _label,
          anchor: Anchor.center,
          position: size / 2,
          textRenderer: TextPaint(
            style: TextStyle(color: textColor, fontSize: 10),
          ),
        );
        add(_text!);
      } else {
        _text!.text = _label!;
      }
    } else {
      _text?.removeFromParent();
      _text = null;
    }
  }

  Sprite? _sprite;
  SpriteComponent? _icon;

  /// The sprite used for the button icon, if any.
  Sprite? get sprite => _sprite;
  set sprite(Sprite? value) {
    _sprite = value;
    if (value != null) {
      if (_icon == null) {
        _icon = SpriteComponent(
          sprite: value,
          anchor: Anchor.center,
          position: size / 2,
        );
        add(_icon!);
      } else {
        _icon!.sprite = value;
      }
    } else {
      _icon?.removeFromParent();
      _icon = null;
    }
  }

  /// The default background color of the button.
  Color color;

  /// The background color of the button when pressed.
  Color pressedColor;

  /// The color of the label text.
  Color textColor;

  TextComponent? _text;

  /// The paint used for the button's background.
  Paint paint;

  /// The style of the paint used for the button's background.
  PaintingStyle paintStyle;

  /// The radius of the circular button.
  double radius;

  /// Creates a [CircleButtonComponent].
  ///
  /// [onPressed] is the callback triggered when the button is pressed.
  /// [label] is the text displayed on the button.
  /// [sprite] is the sprite displayed on the button.
  /// [radius] and [position] define the size and position of the button.
  /// [color] is the default background color.
  /// [pressedColor] is the background color when pressed. Defaults to [color].
  /// [textColor] is the color of the label text.
  CircleButtonComponent({
    required this.onPressed,
    String? label,
    required this.radius,
    required super.position,
    required this.color,
    this.paintStyle = PaintingStyle.fill,
    Sprite? sprite,
    Color? pressedColor,
    this.textColor = Colors.white,
  }) : assert(radius > 0, 'Radius must be greater than zero'),
       assert(
         sprite == null || label == null,
         'Cannot set both sprite and label on CircleButtonComponent',
       ),
       _label = label,
       _sprite = sprite,
       pressedColor = pressedColor ?? color,
       paint =
           Paint()
             ..color = color
             ..style = paintStyle;

  /// Loads the button's components (background and text).
  @override
  Future<void> onLoad() async {
    if (_label != null && _label!.isNotEmpty) {
      _text = TextComponent(
        text: _label,
        anchor: Anchor.center,
        position: size / 2,
        textRenderer: TextPaint(
          style: TextStyle(color: textColor, fontSize: 10),
        ),
      );
      add(_text!);
    } else if (sprite != null) {
      _icon = SpriteComponent(
        sprite: sprite!,
        anchor: Anchor.center,
        position: size / 2,
      );
      add(_icon!);
    }
  }

  /// Handles the tap down event by changing the background color to [pressedColor].
  @override
  void onTapDown(TapDownEvent event) {
    paint.color = pressedColor;
  }

  /// Handles the tap up event by resetting the background color to [color]
  /// and triggering the [onPressed] callback.
  @override
  void onTapUp(TapUpEvent event) {
    paint.color = color;
    onPressed();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(Offset.zero, radius, paint);
  }

  @override
  bool containsLocalPoint(Vector2 point) =>
      point.distanceTo(Vector2.zero()) <= radius;
}
