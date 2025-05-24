# Flame UI

A reusable component library for [Flame](https://flame-engine.org/) games, built with modularity and developer ergonomics in mind.

This package includes stylized UI primitives like text inputs, buttons, modals, lists, and scrollable layouts — all tailored for Flame.

---

## 📦 Installation

Add this to your main app’s `pubspec.yaml`:

```yaml
dependencies:
  flame_ui:
    path: packages/flame_ui
````

---

## 🚀 Components

### `ModalComponent`

A flexible modal window with a scrollable content area and optional title/footer.

```dart
ModalComponent({
  required PositionComponent scrollContent,
  required Vector2 size,
  required Vector2 position,
  String? title,
  EdgeInsets padding = const EdgeInsets.all(8),
  double? contentHeight,
  bool autoContentHeight = true,
  TextStyle? titleStyle,
  double titleSpacing = 2,
  Paint? paint,
  Sprite? closeIcon,
  VoidCallback? onClose,
  VoidCallback? onAfterLoad,
  PositionComponent? footer,
  double defaultFooterHeight = 32,
});
```

---

### `RectButtonComponent`

A simple rectangular button with customizable label and colors.

```dart
RectButtonComponent({
  required VoidCallback onPressed,
  required String label,
  required Vector2 size,
  required Vector2 position,
  Color color = Colors.red,
  Color? pressedColor,
  Color textColor = Colors.white,
});
```

---

### `TextFieldComponent`

A custom input field that uses a hidden Flutter `TextField` overlay for virtual keyboard support.

```dart
TextFieldComponent({
  required Vector2 position,
  required Vector2 size,
  Sprite? background,
  NineTileBox? backgroundNineTile,
  Sprite? focusedBackground,
  NineTileBox? focusedBackgroundNineTile,
  TextStyle textStyle = const TextStyle(color: Colors.white, fontSize: 12),
  OnTextChanged? onChanged,
  String? hintText,
  EdgeInsets padding = EdgeInsets.zero,
  TextEditingController? controller,
});
```

---

### `GridComponent`

A fixed-size grid layout for uniformly sized components.

```dart
GridComponent({
  required List<PositionComponent> childrenComponents,
  required Vector2 childSize,
  Vector2? spacing,
  required Vector2 size,
  required Vector2 position,
});
```

---

### `ScrollableAreaComponent`

A vertically scrollable container with clipping and drag support.

```dart
ScrollableAreaComponent({
  required PositionComponent content,
  required Vector2 size,
  required Vector2 position,
  double? contentHeight,
  bool autoContentHeight = true,
});
```

---

### `ListComponent`

A vertical list of fixed-height children with optional spacing and width.

```dart
ListComponent({
  required List<PositionComponent> childrenComponents,
  required double childHeight,
  double? spacing,
  double? width,
  Vector2? size,
  Vector2? position,
});
```

---

### `ListItemComponent`

A list row with a title, optional subtitle, icon, and trailing action.

```dart
ListItemComponent({
  required String title,
  String? subtitle,
  SpriteComponent? icon,
  PositionComponent? action,
  VoidCallback? onPressed,
  EdgeInsets padding = const EdgeInsets.all(2),
  double spacing = 4,
  TextStyle titleStyle = const TextStyle(fontSize: 10, color: Colors.white),
  TextStyle subtitleStyle = const TextStyle(fontSize: 8, color: Colors.white70),
  Vector2? size,
  Vector2? position,
  Vector2? iconSize,
});
```

---


## 🧪 Example

```dart
import 'package:flame_ui/flame_ui.dart';

final input = TextFieldComponent(
  position: Vector2(10, 20),
  size: Vector2(120, 30),
  hintText: 'Enter name',
  onChanged: (value) => print(value),
);

final button = RectButtonComponent(
  position: Vector2(10, 60),
  size: Vector2(120, 30),
  label: 'Submit',
  onPressed: () => print('Pressed!'),
);
```

---

## 📌 Notes

* All components are Flame `PositionComponent`s and integrate seamlessly with Flame's coordinate system.
* Many components use `NineTileBox` or `Sprite` backgrounds and require assets to be loaded.
* `TextFieldComponent` needs `game.buildContext` to work (e.g. `GameWidget()` inside a `MaterialApp`).

---

## 🛠 Roadmap

* [ ] Cursor + selection support in `TextFieldComponent`
* [ ] Prebuilt themes/styles
* [ ] Dropdowns, toggles, and tabs
* [ ] RTL / accessibility support

---

## 📝 License

MIT — use freely, modify generously.
