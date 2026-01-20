import 'dart:ui' as ui;
import 'package:image_picker/image_picker.dart';

Future<ui.Image> convertXFileToImage(XFile file) async {
  final bytes = await file.readAsBytes();
  final codec = await ui.instantiateImageCodec(bytes);
  final frame = await codec.getNextFrame();
  return frame.image;
}
