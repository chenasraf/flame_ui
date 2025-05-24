// ignore_for_file: avoid_print

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flame_ui/flame_ui.dart';

void main() {
  runApp(MaterialApp(home: GameWidget(game: FlameUIExample())));
}

class FlameUIExample extends FlameGame
    with TapCallbacks, HasKeyboardHandlerComponents {
  late TextFieldComponent nameField;
  late ModalComponent modal;

  @override
  Future<void> onLoad() async {
    final screenSize = size;

    final rootContainer = PositionComponent(
      position: Vector2.zero(),
      size: Vector2(screenSize.x, 400), // Tall enough to scroll
    );

    // TextField
    nameField = TextFieldComponent(
      position: Vector2(20, 20),
      size: Vector2(180, 32),
      hintText: 'Enter name',
      backgroundNineTile: NineTileBox(
        Sprite(await images.load('textbox.png')),
        tileSize: 16,
        destTileSize: 16,
      ),
      textStyle: const TextStyle(color: Colors.white, fontSize: 12),
      onChanged: (value) => print('Text changed: $value'),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
    rootContainer.add(nameField);

    // RectButton that shows modal
    final showModalButton = RectButtonComponent(
      label: 'Show Modal',
      position: Vector2(20, 60),
      size: Vector2(100, 28),
      onPressed: _showModal,
    );
    rootContainer.add(showModalButton);

    // ListComponent with ListItems
    final list = ListComponent(
      children: List.generate(3, (i) {
        return ListItemComponent(
          title: 'Item ${i + 1}',
          subtitle: 'Subtitle ${i + 1}',
          size: Vector2(180, 36),
          onPressed: () => print('Tapped item $i'),
        );
      }),
      childHeight: 40,
      spacing: 8,
      size: Vector2(180, 140),
      position: Vector2(20, 100),
    );
    rootContainer.add(list);

    // GridComponent
    final grid = GridComponent(
      children: List.generate(4, (i) {
        return RectButtonComponent(
          label: 'G$i',
          size: Vector2.all(36),
          position: Vector2.zero(),
          onPressed: () => print('Grid $i'),
        );
      }),
      childSize: Vector2.all(36),
      spacing: Vector2.all(4),
      size: Vector2(100, 100),
      position: Vector2(20, 260),
    );
    rootContainer.add(grid);

    // Wrap everything in scrollable area
    final scrollable = ScrollableAreaComponent(
      content: rootContainer,
      size: screenSize,
      position: Vector2.zero(),
      autoContentHeight: true,
    );

    add(scrollable);
  }

  Future<void> _showModal() async {
    final modalContent = ListComponent(
      children: List.generate(5, (i) {
        return ListItemComponent(
          title: 'Modal Item ${i + 1}',
          size: Vector2(160, 30),
        );
      }),
      childHeight: 32,
      spacing: 6,
      size: Vector2(180, 180),
      position: Vector2.zero(),
    );

    modal = ModalComponent(
      closeIcon: Sprite(await images.load('cross.png')),
      scrollContent: modalContent,
      size: Vector2(200, 200),
      position: size / 2 - Vector2(100, 100),
      title: 'Modal Title',
      onClose: () => remove(modal),
    );

    add(modal);
  }
}

