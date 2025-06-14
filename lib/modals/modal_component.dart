import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' show Colors, TextStyle, EdgeInsets;
import 'package:flutter/painting.dart';

import '../layout/scrollable_area_component.dart';

/// A modal dialog component that can display content, a title, a footer, and a close button.
///
/// This component is designed to be used in a Flame game and provides a scrollable
/// area for its content, along with customizable styling and behavior.
class ModalComponent extends PositionComponent with HasGameReference {
  PositionComponent _scrollContent;
  String? _title;
  EdgeInsets _padding;
  double? _contentHeight;
  bool _autoContentHeight;
  TextStyle? _titleStyle;
  double _titleSpacing;
  PositionComponent? _leading;
  PositionComponent? _trailing;
  PositionComponent? _footer;
  PositionComponent? _background;
  double? _scrollDamping;

  /// The callback to invoke after the modal has finished loading.
  VoidCallback? onAfterLoad;

  /// The default height of the footer if its size is not explicitly set.
  double defaultFooterHeight;

  /// The scrollable area component for the modal's content.
  late ScrollableAreaComponent scrollArea;

  /// The background rectangle component for the modal.
  late PositionComponent _backgroundComponent;

  /// The text component for the title, if a title is provided.
  late TextComponent? titleComponent;

  /// Static callback for after load event, useful for initialization or registering the modal in a stack.
  static void Function(ModalComponent modal)? onAfterLoadStatic;

  /// Static callback for before unload event, useful for cleanup.
  static void Function(ModalComponent modal)? onBeforeUnloadStatic;

  /// Creates a [ModalComponent] with the given parameters.
  ///
  /// [scrollContent] is required and specifies the content to display inside the modal.
  /// [size] specifies the size of the modal.
  /// [position] specifies the position of the modal.
  /// [title] is optional and specifies the title of the modal.
  /// [padding] specifies the padding around the content (default is 8).
  /// [contentHeight] optionally specifies the height of the content.
  /// [autoContentHeight] determines if the content height should be automatically calculated (default is true).
  /// [titleStyle] specifies the text style for the title.
  /// [titleSpacing] specifies the spacing between the title and the content (default is 2).
  /// [paint] optionally specifies the paint for the background.
  /// [background] allows passing a custom component to use as the modal background instead of a default rectangle.
  /// [leading] optionally provides a component to render in the top-left corner.
  /// [trailing] optionally provides a component to render in the top-right corner.
  /// [onAfterLoad] optionally specifies a callback after the modal has loaded.
  /// [footer] optionally specifies a footer component to display at the bottom.
  /// [defaultFooterHeight] specifies the default height of the footer (default is 32).
  /// [scrollDamping] specifies the damping factor for scroll velocity (default is 500.0).
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
    PositionComponent? leading,
    PositionComponent? trailing,
    this.onAfterLoad,
    PositionComponent? footer,
    PositionComponent? background,
    this.defaultFooterHeight = 32,
    double scrollDamping = 500.0,
  }) : _scrollContent = scrollContent,
       _title = title,
       _padding = padding,
       _contentHeight = contentHeight,
       _autoContentHeight = autoContentHeight,
       _titleStyle = titleStyle,
       _titleSpacing = titleSpacing,
       _leading = leading,
       _trailing = trailing,
       _footer = footer,
       _background = background,
       _scrollDamping = scrollDamping,
       super(size: size, position: position);

  /// The content to be displayed inside the scrollable area of the modal.
  PositionComponent get scrollContent => _scrollContent;
  set scrollContent(PositionComponent value) {
    _scrollContent = value;
    rebuild();
  }

  /// The optional title of the modal.
  String? get title => _title;
  set title(String? value) {
    _title = value;
    rebuild();
  }

  /// The padding around the content of the modal.
  EdgeInsets get padding => _padding;
  set padding(EdgeInsets value) {
    _padding = value;
    rebuild();
  }

  /// The height of the content. If null, it will be resolved based on [autoContentHeight].
  double? get contentHeight => _contentHeight;
  set contentHeight(double? value) {
    _contentHeight = value;
    rebuild();
  }

  /// Whether to automatically determine the content height based on the size of the content.
  bool get autoContentHeight => _autoContentHeight;
  set autoContentHeight(bool value) {
    _autoContentHeight = value;
    rebuild();
  }

  /// The text style for the title.
  TextStyle? get titleStyle => _titleStyle;
  set titleStyle(TextStyle? value) {
    _titleStyle = value;
    rebuild();
  }

  /// The spacing between the title and the content.
  double get titleSpacing => _titleSpacing;
  set titleSpacing(double value) {
    _titleSpacing = value;
    rebuild();
  }

  /// The custom background of the modal.
  PositionComponent get background => _background ?? _backgroundComponent;
  set background(PositionComponent value) {
    _background = value;
    rebuild();
  }

  /// An optional component to render in the top-left corner of the modal.
  ///
  /// The component will be automatically positioned based on [padding] and its own size.
  PositionComponent? get leading => _leading;
  set leading(PositionComponent? value) {
    _leading = value;
    rebuild();
  }

  /// An optional component to render in the top-right corner of the modal.
  ///
  /// The component will be automatically positioned based on [padding] and its own size.
  PositionComponent? get trailing => _trailing;
  set trailing(PositionComponent? value) {
    _trailing = value;
    rebuild();
  }

  /// The optional footer component to display at the bottom of the modal.
  PositionComponent? get footer => _footer;
  set footer(PositionComponent? value) {
    _footer = value;
    rebuild();
  }

  /// The damping factor for scroll velocity, used in the scrollable area.
  double get scrollDamping => _scrollDamping ?? 500.0;
  set scrollDamping(double value) {
    _scrollDamping = value;
    scrollArea.damping = value;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await rebuild();
  }

  /// Rebuilds the modal layout, useful when modifying properties like [scrollContent], [title], [footer], etc.
  Future<void> rebuild() async {
    removeAll(children);

    _backgroundComponent =
        _background ??
        RectangleComponent(size: size, paint: Paint()..color = Colors.black87);
    _backgroundComponent.size = size;
    _backgroundComponent.position = Vector2.zero();
    add(_backgroundComponent);

    double scrollTop = padding.top;
    double scrollBottom = padding.bottom;

    titleComponent = null;
    if (title != null) {
      titleComponent = TextComponent(
        text: title!,
        anchor: Anchor.topLeft,
        position: Vector2(padding.left, scrollTop),
        textRenderer: TextPaint(
          style:
              titleStyle ??
              const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
      );
      add(titleComponent!);
      await titleComponent!.onLoad();
      scrollTop += titleComponent!.height + titleSpacing;
    }

    if (trailing != null) {
      await trailing!.onLoad();
      trailing!
        ..position = Vector2(
          size.x - padding.right - trailing!.size.x,
          padding.top,
        )
        ..anchor = Anchor.topLeft;
      add(trailing!);
    }

    if (footer != null) {
      await footer!.onLoad();
      final footerHeight =
          footer!.size.y > 0 ? footer!.size.y : defaultFooterHeight;
      scrollBottom += footerHeight + titleSpacing;
      footer!.position = Vector2(
        padding.left,
        size.y - scrollBottom + titleSpacing,
      );
      add(footer!);
    }

    final scrollAreaSize = Vector2(
      size.x - padding.horizontal,
      size.y - scrollTop - scrollBottom,
    );

    scrollArea = ScrollableAreaComponent(
      content: scrollContent,
      size: scrollAreaSize,
      position: Vector2(padding.left, scrollTop),
      contentHeight: contentHeight,
      autoContentHeight: autoContentHeight,
    );
    add(scrollArea);

    onAfterLoad?.call();
  }

  /// Displays the modal by adding it to the game's viewport.
  /// Calls [onAfterLoadStatic] after loading.
  Future<void> show(FlameGame game) async {
    await game.camera.viewport.add(this);
    onAfterLoadStatic?.call(this);
  }

  /// Hides the modal by removing it from the game's viewport.
  /// Calls [onBeforeUnloadStatic] before unloading.
  void hide() {
    onBeforeUnloadStatic?.call(this);
    return game.camera.viewport.remove(this);
  }
}
