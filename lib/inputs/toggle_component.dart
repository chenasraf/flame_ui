import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/widgets.dart';

/// A toggleable component that switches between two visual states when tapped.
///
/// This component allows you to define two visual states (enabled and disabled)
/// and toggles between them when tapped. It supports custom animations during the toggle,
/// provides a callback for value changes, and can be marked non-interactive via [disabled].
///
/// ### Example: Animate a child icon when toggled
///
/// ```dart
/// final icon = SpriteComponent(sprite: yourIcon, size: Vector2.all(12))
///   ..position = Vector2(10, 10);
///
/// final onVisual = RectangleComponent(size: Vector2.all(32), children: [icon]);
/// final offVisual = RectangleComponent(size: Vector2.all(32));
///
/// final toggle = ToggleComponent(
///   value: false,
///   onChanged: (val) => print('Toggled to $val'),
///   valueOn: onVisual,
///   valueOff: offVisual,
///   onAnimate: (visual, newValue) {
///     // Move the icon upward briefly when toggled
///     final icon = visual.children.query<SpriteComponent>().first;
///     icon.add(
///       MoveEffect.by(
///         Vector2(0, -4),
///         EffectController(duration: 0.1, reverseDuration: 0.1, alternate: true),
///       ),
///     );
///   },
/// );
/// ```
class ToggleComponent extends PositionComponent with TapCallbacks {
  /// The current value of the toggle. `true` for enabled, `false` for disabled.
  bool _value;

  /// Callback invoked when the toggle value changes.
  ValueChanged<bool> _onChanged;

  /// The visual component displayed when the toggle is enabled.
  PositionComponent _valueOn;

  /// The visual component displayed when the toggle is disabled.
  PositionComponent _valueOff;

  /// Optional visual to show when the toggle is disabled from interaction.
  PositionComponent? _disabledComponent;

  /// Whether the component is interactable.
  bool disabled;

  /// Optional animation callback to run on toggle.
  /// This function receives the visual component being displayed and the new value.
  void Function(PositionComponent visual, bool newValue)? onAnimate;

  /// Creates a [ToggleComponent] with custom visual components.
  ///
  /// [value] is the initial state of the toggle.
  /// [onChanged] is the callback invoked when the toggle value changes.
  /// [valueOn] is the visual component for the enabled state.
  /// [valueOff] is the visual component for the disabled state.
  /// [disabledComponent] is shown when [disabled] is true (optional).
  ToggleComponent({
    required bool value,
    required ValueChanged<bool> onChanged,
    required PositionComponent valueOn,
    required PositionComponent valueOff,
    PositionComponent? disabledComponent,
    this.disabled = false,
    this.onAnimate,
    Vector2? position,
    Vector2? size,
  }) : _value = value,
       _onChanged = onChanged,
       _valueOn = valueOn,
       _valueOff = valueOff,
       _disabledComponent = disabledComponent,
       super(
         position: position ?? Vector2.zero(),
         size: size ?? valueOn.size.clone(),
       );

  /// Convenience constructor for creating a [ToggleComponent] with sprites.
  ///
  /// [value] is the initial state of the toggle.
  /// [onChanged] is the callback invoked when the toggle value changes.
  /// [enabledSprite] is the sprite for the enabled state.
  /// [disabledSprite] is the sprite for the disabled state.
  /// [disabledVisualSprite] is the sprite shown when [disabled] is true (optional).
  ToggleComponent.sprite({
    required bool value,
    required ValueChanged<bool> onChanged,
    required Sprite enabledSprite,
    required Sprite disabledSprite,
    Sprite? disabledVisualSprite,
    Vector2? position,
    Vector2? size,
    Vector2? spriteSize,
    this.disabled = false,
    this.onAnimate,
  }) : _value = value,
       _onChanged = onChanged,
       _valueOn = SpriteComponent(
         sprite: enabledSprite,
         size: spriteSize ?? size ?? Vector2.all(32),
       ),
       _valueOff = SpriteComponent(
         sprite: disabledSprite,
         size: spriteSize ?? size ?? Vector2.all(32),
       ),
       _disabledComponent =
           disabledVisualSprite != null
               ? SpriteComponent(
                 sprite: disabledVisualSprite,
                 size: spriteSize ?? size ?? Vector2.all(32),
               )
               : null,
       super(
         position: position ?? Vector2.zero(),
         size: size ?? spriteSize ?? Vector2.all(32),
       );

  /// Gets the current value of the toggle.
  bool get value => _value;

  /// Sets the current value of the toggle and rebuilds the visual state.
  set value(bool newValue) {
    if (_value != newValue) {
      _value = newValue;
      _rebuild();
    }
  }

  /// Sets the callback invoked when the toggle value changes.
  set onChanged(ValueChanged<bool> callback) => _onChanged = callback;

  /// Gets the visual component for the enabled state.
  PositionComponent get valueOn => _valueOn;

  /// Sets the visual component for the enabled state and rebuilds the visual state.
  set valueOn(PositionComponent component) {
    _valueOn = component;
    _rebuild();
  }

  /// Gets the visual component for the disabled state.
  PositionComponent get valueOff => _valueOff;

  /// Sets the visual component for the disabled state and rebuilds the visual state.
  set valueOff(PositionComponent component) {
    _valueOff = component;
    _rebuild();
  }

  /// Gets the visual component for the disabled interaction state.
  PositionComponent? get disabledComponent => _disabledComponent;

  /// Sets the visual component for the disabled interaction state and rebuilds the visual state.
  set disabledComponent(PositionComponent? component) {
    _disabledComponent = component;
    _rebuild();
  }

  /// Sets whether the component is interactable and rebuilds the visual state.
  set isDisabled(bool newValue) {
    if (disabled != newValue) {
      disabled = newValue;
      _rebuild();
    }
  }

  /// Gets whether the component is interactable.
  bool get isDisabled => disabled;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _rebuild();
  }

  /// Rebuilds the visual state of the toggle component.
  void _rebuild() {
    removeAll(children);

    final visual =
        disabled
            ? _disabledComponent ?? (_value ? _valueOn : _valueOff)
            : (_value ? _valueOn : _valueOff);

    visual.position = Vector2.zero();
    visual.size = size;
    add(visual);

    if (!disabled && onAnimate != null) {
      onAnimate!(visual, _value);
    }
  }

  @override
  bool onTapDown(TapDownEvent event) {
    if (disabled) return false;

    value = !_value;
    _onChanged(_value);
    return true;
  }
}
