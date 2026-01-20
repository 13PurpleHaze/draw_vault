import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'models/models.dart';

class Canvas extends StatefulWidget {
  final Color currentColor;
  final double currentWidth;
  final bool isEraser;
  final Key canvasKey;
  final ui.Image? image;

  const Canvas({
    super.key,
    required this.currentColor,
    required this.currentWidth,
    required this.isEraser,
    required this.canvasKey,
    this.image,
  });

  @override
  State<Canvas> createState() => _CanvasState();
}

class _CanvasState extends State<Canvas> {
  final List<Stroke> strokes = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanStart: (details) {
        setState(() {
          strokes.add(
            Stroke(
              points: [details.localPosition],
              color: widget.currentColor,
              width: widget.currentWidth,
              isEraser: widget.isEraser,
            ),
          );
        });
      },
      onPanUpdate: (d) {
        setState(() {
          strokes.last.points.add(d.localPosition);
        });
      },
      onPanEnd: (_) {},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: ClipRect(
          child: RepaintBoundary(
            key: widget.canvasKey,
            child: CustomPaint(
              painter: AppCustomPainter(
                strokes: strokes,
                backgroundImage: widget.image,
              ),
              child: Container(),
            ),
          ),
        ),
      ),
    );
  }
}
