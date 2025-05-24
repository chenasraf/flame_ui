# Flame UI

A reusable component library for [Flame](https://flame-engine.org/) games, built with modularity and
developer ergonomics in mind.

This package includes stylized UI primitives like text inputs, buttons, modals, lists, and
scrollable layouts — all tailored for Flame.

---

## 📦 Installation

Add this to your main app’s `pubspec.yaml`:

```sh
flutter pub add flame_ui
```

---

## 🚀 Components

Each component is fully documented in its own file. Below is a high-level overview of what’s
available.

---

### `ModalComponent`

A flexible modal window that wraps any component in a styled, scrollable dialog.

- Supports a title, scrollable content, and optional footer.
- Customize layout via padding, title spacing, and content height behavior.
- Optional close icon and callback hooks (`onClose`, `onAfterLoad`).

---

### `RectButtonComponent`

A tappable rectangular button with a customizable label.

- Supports background color, text color, and pressed state color.
- Designed for quick interaction without layout boilerplate.

---

### `TextFieldComponent`

A virtual keyboard–enabled text field powered by an overlayed Flutter `TextField`.

- Supports `Sprite` or `NineTileBox` backgrounds for normal and focused states.
- Customizable text style, hint text, and internal padding.
- Supports external controller and `onChanged` callback.

---

### `GridComponent`

A layout component for arranging children in a uniform grid.

- Fixed-size cells with optional spacing.
- Automatically places components row by row.

---

### `ScrollableAreaComponent`

A vertical scroll container that clips its contents and handles drag gestures.

- Use when your content may overflow vertically (e.g., on small watch screens).
- Dynamically adjusts scroll limits based on content size.

---

### `ListComponent`

A vertical list layout for displaying uniform-height items.

- Supports spacing between items and optional custom width.
- Designed for use with `ListItemComponent` or similar items.

---

### `ListItemComponent`

A reusable list row for text and optional leading/trailing content.

- Displays a title, optional subtitle, icon, and trailing component (like a button).
- Fully styleable with text styles, padding, spacing, and icon sizing.
- Tapable row with `onPressed` callback support.

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

- All components are Flame `PositionComponent`s and integrate seamlessly with Flame's coordinate
  system.
- Many components use `NineTileBox` or `Sprite` backgrounds and require assets to be loaded.
- `TextFieldComponent` needs `game.buildContext` to work (e.g. `GameWidget()` inside a
  `MaterialApp`).

---

## 🛠 Roadmap

- [ ] Cursor + selection support in `TextFieldComponent`
- [ ] Prebuilt themes/styles
- [ ] Dropdowns, toggles, and tabs
- [ ] RTL / accessibility support

---

## 📝 License

MIT — use freely, modify generously.
