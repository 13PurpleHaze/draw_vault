import 'dart:typed_data';
import 'dart:ui' as ui;

Future<ui.Image> convertUint8ListToImage(Uint8List data) async {
  final codec = await ui.instantiateImageCodec(data);
  final frame = await codec.getNextFrame();

  return frame.image;
}
