import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

/// A component that catches global tap events and notifies registered fields
/// when a tap occurs outside their bounds.
///
/// Use [register] with any [TapOutsideCallbacks] to receive outside tap notifications.
/// This is useful for dismissing overlays, popups, or input fields when
/// tapping elsewhere in the game. Use [unregister] when the component is removed or no longer
/// needs to receive notifications.
///
/// To use this, ensure that the game has a [TapOutsideHandler] added to it, you can
/// use the `ensureGlobalTapCatcher` method on the game instance.
/// Run it before adding any components that need to handle outside taps, such as the game init.
/// If you want to load it inside [onLoad] of a component, make sure not to await it directly,
/// as it will block the component from loading while waiting for the game lifecycle to process.
/// Instead, use an unawaited method, or use `then` to wait without blocking.
///
/// Example usage:
///
/// ```dart
/// @override
/// Future<void> onLoad() async {
///   super.onLoad();
///   game.ensureGlobalTapCatcher().then((catcher) => catcher.register(this));
/// }
/// ```
class TapOutsideHandler extends Component with TapCallbacks, HasGameReference {
  final Set<TapOutsideCallbacks> _registeredFields = {};

  Future<TapOutsideHandler> attach(FlameGame game) {
    return game.ensureGlobalTapCatcher();
  }

  /// Registers a [TapOutsideCallbacks] to receive outside tap notifications.
  void register(TapOutsideCallbacks field) => _registeredFields.add(field);

  /// Unregisters a [TapOutsideCallbacks] from receiving outside tap notifications.
  void unregister(TapOutsideCallbacks field) => _registeredFields.remove(field);

  @override
  void onTapDown(TapDownEvent event) {
    for (final field in _registeredFields) {
      final rect = field.toAbsoluteRect();
      final tapPos = event.canvasPosition.toOffset();

      // Notify the field if the tap was outside its bounds.
      if (!rect.contains(tapPos)) {
        field.onTapDownOutside(event);
      }
    }
    event.continuePropagation = true;
  }

  @override
  void onTapUp(TapUpEvent event) {
    for (final field in _registeredFields) {
      final rect = field.toAbsoluteRect();
      final tapPos = event.canvasPosition.toOffset();

      // Notify the field if the tap was outside its bounds.
      if (!rect.contains(tapPos)) {
        field.onTapUpOutside(event);
      }
    }
    event.continuePropagation = true;
  }

  @override
  /// Always returns true to catch all tap events globally.
  bool containsLocalPoint(Vector2 point) => true;
}

/// Mixin for components that want to be notified when a tap occurs outside
/// their bounds via [TapOutsideHandler].
///
/// To use this mixin, a component must implement the `onTapDownOutside` or
/// `onTapUpOutside` methods to handle the tap events that occur outside.
mixin TapOutsideCallbacks on PositionComponent {
  /// Called when a tap down event occurs outside this component's bounds.
  void onTapDownOutside(TapDownEvent event) {}

  /// Called when a tap up event occurs outside this component's bounds.
  void onTapUpOutside(TapUpEvent event) {}
}

extension GlobalTapCatcherMixin on FlameGame {
  /// Adds a [TapOutsideHandler] to the game if it doesn't already exist.
  Future<TapOutsideHandler> ensureGlobalTapCatcher() async {
    if (children.query<TapOutsideHandler>().isEmpty) {
      await add(TapOutsideHandler());
    }
    return lifecycleEventsProcessed.then((_) {
      return children.query<TapOutsideHandler>().first;
    });
  }

  TapOutsideHandler get globalTapCatcher =>
      children.query<TapOutsideHandler>().firstOrNull ??
      (TapOutsideHandler()..attach(this));
}
