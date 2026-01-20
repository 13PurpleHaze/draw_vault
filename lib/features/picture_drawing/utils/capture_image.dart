import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

Future<ui.Image> captureImage({required GlobalKey canvasKey}) async {
  RenderRepaintBoundary boundary =
      canvasKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
  return await boundary.toImage(pixelRatio: 3.0);
}
