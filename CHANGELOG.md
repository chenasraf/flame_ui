## 0.0.4

- `TextFieldComponent`: Support generic components for background/backgroundFocused
- `ModalComponent`: Support for `scrollDamping`
- `ModalComponent`: Add `onAfterLoadStatic` and `onBeforeUnloadStatic` as lifecycle callbacks across
  all ModalComponent usages

## 0.0.3

- `ModalComponent`: All configurable properties are now mutable via getters and setters.
- `ModalComponent`: Automatically calls `rebuild()` when a property is changed at runtime, enabling
  dynamic UI updates.
- `ModalComponent`: Add customizable background component property
- `ScrollableAreaComponent`: Added support for fling scrolling

## 0.0.2

- `RectButtonComponent`: Make color mandatory
- `ModalComponent`: Support any component as closeButton

## 0.0.1

Initial release.

Components:

- `TextFieldComponent`
- `RectButtonComponent`
- `ModalComponent`
- `ScrollableAreaComponent`
- `GridComponent`
- `ListComponent`
- `ListItemComponent`
