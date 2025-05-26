import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

/// A callback type for handling text changes.
typedef OnTextChanged = void Function(String);

/// A custom text field component for Flame games, supporting focus, rendering,
/// and interaction with a virtual keyboard.
class TextFieldComponent extends PositionComponent
    with TapCallbacks, HasGameReference {
  /// Generic background component when not focused.
  final PositionComponent? background;

  /// Generic background component when focused.
  final PositionComponent? backgroundFocused;

  /// Text style for the text content.
  final TextStyle textStyle;

  /// Callback triggered when the text changes.
  final OnTextChanged? onChanged;

  /// Hint text displayed when the text field is empty.
  final String? hintText;

  /// Indicates whether the text field is currently focused.
  bool isFocused = false;

  /// Text paint for rendering the text.
  late final TextPaint textPaint;

  /// Text paint for rendering the hint text.
  late final TextPaint hintTextPaint;

  /// Focus node for managing focus state.
  final FocusNode _focusNode = FocusNode();

  /// Controller for managing the text input.
  late final TextEditingController _controller;

  /// Padding inside the text field.
  final EdgeInsets padding;

  /// Overlay entry for displaying the virtual keyboard.
  OverlayEntry? _overlayEntry;

  /// Creates a [TextFieldComponent].
  ///
  /// [position] and [size] define the position and size of the text field.
  /// Accepts generic background components for both states.
  TextFieldComponent({
    required Vector2 position,
    required Vector2 size,
    this.background,
    this.backgroundFocused,
    this.textStyle = const TextStyle(color: Colors.white, fontSize: 12),
    this.onChanged,
    this.hintText,
    this.padding = EdgeInsets.zero,
    TextEditingController? controller,
  }) : super(position: position, size: size) {
    _controller = controller ?? TextEditingController();
    textPaint = TextPaint(style: textStyle);
    hintTextPaint = TextPaint(
      style: textStyle.copyWith(
        color: (textStyle.color ?? Colors.white).withAlpha(127),
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final bg = isFocused ? backgroundFocused ?? background : background;

    if (bg is SpriteComponent && bg.sprite != null) {
      bg.sprite!.render(canvas, size: size);
    } else if (bg is NineTileBoxComponent && bg.nineTileBox != null) {
      bg.nineTileBox!.draw(canvas, Vector2.zero(), size);
    } else if (bg != null) {
      bg.position = Vector2.zero();
      bg.size = size;
      bg.render(canvas);
    }

    final textOffset = Vector2(
      padding.left,
      (size.y - textStyle.fontSize!) / 2,
    );
    if (_controller.text.isNotEmpty) {
      textPaint.render(canvas, _controller.text, textOffset);
    } else if (hintText?.isNotEmpty == true) {
      hintTextPaint.render(canvas, hintText!, textOffset);
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    _focus();
  }

  void _focus() {
    if (isFocused) return;
    isFocused = true;
    _showKeyboardOverlay();
  }

  void _unfocus() {
    if (!isFocused) return;
    isFocused = false;
    _overlayEntry?.remove();
    _overlayEntry = null;
    _focusNode.unfocus();
  }

  void _showKeyboardOverlay() {
    final context = game.buildContext;
    if (context == null) return;

    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox?;
    final gameOffset = renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
    final componentOffset = Offset(position.x, position.y);
    final screenPosition = gameOffset + componentOffset;

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            left: screenPosition.dx + padding.left,
            top: screenPosition.dy + padding.top,
            width: size.x - padding.horizontal,
            height: size.y - padding.vertical,
            child: Material(
              color: Colors.transparent,
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                autofocus: true,
                style: textStyle.copyWith(color: textStyle.color!.withAlpha(0)),
                decoration: InputDecoration.collapsed(hintText: ''),
                onChanged: onChanged,
                cursorColor: textStyle.color,
              ),
            ),
          ),
    );

    overlay.insert(_overlayEntry!);
    _focusNode.requestFocus();
  }

  @override
  void onRemove() {
    _unfocus();
    super.onRemove();
  }
}
