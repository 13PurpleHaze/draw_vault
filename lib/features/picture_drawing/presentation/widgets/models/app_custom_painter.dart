import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'stroke.dart';

// Custom painter для канваса
class AppCustomPainter extends CustomPainter {
  final List<Stroke> strokes;
  final ui.Image? backgroundImage;

  AppCustomPainter({required this.strokes, required this.backgroundImage});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(20));

    // Обрезаем сначала углы
    canvas.clipRRect(rrect);
    // Если есть картинка рисуем ее
    // drawImageRect вместо drawImage потому, что drawImage ресует картинку во весь размер
    // у drawImageRect есть параметры src и dst, чтобы настроить какую часть изображения взять(src)
    // dst чтобы нарисовать изображение в определенной части холста
    if (backgroundImage != null) {
      final paint = Paint();

      // Нужно чтобы картинка не растягивалась, а действовала подобно fit: contains
      final imageWidth = backgroundImage!.width;
      final imageHeight = backgroundImage!.height;

      final imageAspect = imageWidth / imageHeight;
      final canvasAspect = size.width / size.height;

      Rect srcRect;

      // Если картинка шире, то нужно обрезать по ширине, иначе по высоте
      if (imageAspect > canvasAspect) {
        final newWidth = imageHeight * canvasAspect;
        final dx = (imageWidth - newWidth) / 2;
        srcRect = Rect.fromLTWH(dx, 0, newWidth, imageHeight.toDouble());
      } else {
        final newHeight = imageWidth / canvasAspect;
        final dy = (imageHeight - newHeight) / 2;
        srcRect = Rect.fromLTWH(0, dy, imageWidth.toDouble(), newHeight);
      }

      canvas.drawImageRect(
        backgroundImage!,
        srcRect,
        Rect.fromLTWH(0, 0, size.width, size.height),
        paint,
      );
    } else {
      // фон должен быть белый
      final paint = Paint();
      paint.color = Colors.white;
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    }
    // создаем новый слой, все операции ниже рисуются на нем а не на основном
    // это нужно чтобы применить blendMode
    canvas.saveLayer(rect, Paint());

    for (final stroke in strokes) {
      final paint = Paint()
        ..strokeWidth = stroke.width
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..blendMode = stroke.isEraser ? BlendMode.clear : BlendMode.srcOver
        ..color = stroke.color;

      for (int i = 1; i < stroke.points.length; i++) {
        canvas.drawLine(stroke.points[i - 1], stroke.points[i], paint);
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
