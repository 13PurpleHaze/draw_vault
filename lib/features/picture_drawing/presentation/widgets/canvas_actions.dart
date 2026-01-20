import 'package:flutter/material.dart';

import 'package:draw_vault/app/shared/shared.dart';

class CanvasActions extends StatelessWidget {
  final double currentWidth;
  final Color currentColor;
  final bool isEraser;
  final void Function() onPickImagePressed;
  final void Function() onShareToGalleryPressed;
  final void Function() onEraserPressed;
  final void Function(double newWidth) onWidthPressed;
  final void Function(Color pickedColor) onColorPicked;

  const CanvasActions({
    super.key,
    required this.currentWidth,
    required this.currentColor,
    required this.isEraser,
    required this.onPickImagePressed,
    required this.onShareToGalleryPressed,
    required this.onEraserPressed,
    required this.onWidthPressed,
    required this.onColorPicked,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton.filledTonal(
          onPressed: onShareToGalleryPressed,
          icon: Image.asset('assets/icons/download.png'),
        ),
        IconButton.filledTonal(
          onPressed: onPickImagePressed,
          icon: Image.asset('assets/icons/gallery.png'),
        ),
        IconButton.filledTonal(
          onPressed: () {
            showStroke(
              context: context,
              currentWidth: currentWidth,
              isEraser: isEraser,
              currentColor: currentColor,
              onWidthSelected: onWidthPressed,
            );
          },
          icon: Image.asset('assets/icons/edit.png'),
        ),
        IconButton.filledTonal(
          isSelected: !isEraser,
          onPressed: onEraserPressed,
          icon: Image.asset('assets/icons/eraser.png'),
        ),
        IconButton.filledTonal(
          onPressed: () {
            showColorPicker(context: context, onColorPicked: onColorPicked);
          },
          icon: Image.asset('assets/icons/colors.png'),
        ),
      ],
    );
  }
}
