// ignore_for_file: avoid_print

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
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

    final rootContainer = RectangleComponent(
      position: Vector2.zero(),
      size: Vector2(screenSize.x, 400), // Tall enough to scroll
      paint: Paint()..color = Colors.blue[900]!,
    );

    // TextField
    nameField = TextFieldComponent(
      position: Vector2(20, 20),
      size: Vector2(180, 32),
      hintText: 'Enter name',
      background: NineTileBoxComponent(
        nineTileBox: NineTileBox(
          Sprite(await images.load('textbox.png')),
          tileSize: 16,
          destTileSize: 16,
        ),
      ),
      textStyle: const TextStyle(color: Colors.white, fontSize: 12),
      onChanged: (value) => print('Text changed: $value'),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
    rootContainer.add(nameField);

    // RectButton that shows modal
    final showModalButton = RectangleButtonComponent(
      label: 'Show Modal',
      position: Vector2(20, 60),
      size: Vector2(100, 28),
      color: Colors.red,
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
        return CircleButtonComponent(
          label: 'G$i',
          radius: 18,
          position: Vector2.zero(),
          color: Colors.blue,
          onPressed: () => print('Grid $i'),
        );
      }),
      childSize: Vector2.all(36),
      spacing: Vector2.all(4),
      size: Vector2(100, 100),
      position: Vector2(40, 260),
    );
    rootContainer.add(grid);

    final visual = RectangleComponent(
      size: Vector2(80, 32),
      paint: Paint()..color = Colors.green,
      children: [_ToggleIndicator(radius: 16, position: Vector2(40, 16))],
    );

    late ToggleComponent toggle;
    toggle = ToggleComponent(
      position: Vector2(20, 340),
      value: false,
      onChanged: (val) {
        print('Toggled to $val');
        toggle.value = val;
      },
      valueOn: visual,
      valueOff: visual,
      onAnimate: (visual, newValue) {
        // Move the icon upward briefly when toggled
        final indicator = visual.children.query<_ToggleIndicator>().first;
        final amount = 24.0;
        indicator.add(
          MoveEffect.by(
            Vector2(newValue ? amount : -amount, 0),
            EffectController(duration: 0.3, curve: Curves.easeInOut),
          ),
        );
      },
    );

    rootContainer.add(toggle);

    // Wrap everything in scrollable area
    final scrollable = ScrollableAreaComponent(
      content: rootContainer,
      size: screenSize,
      position: Vector2(0, 60),
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

    final sprite = Sprite(await images.load('cross.png'));
    modal = ModalComponent(
      trailing: SpriteButtonComponent(
        button: sprite,
        buttonDown: sprite,
        size: Vector2.all(16),
        onPressed: () => remove(modal),
      ),
      scrollContent: modalContent,
      size: Vector2(200, 200),
      position: size / 2 - Vector2(100, 100),
      title: 'Modal Title',
    );

    add(modal);
  }
}

class _ToggleIndicator extends PositionComponent {
  double radius;
  _ToggleIndicator({super.position, required this.radius});

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(
      Offset(position.x - radius, position.y - radius),
      radius,
      Paint()..color = Colors.red,
    );
  }
}
