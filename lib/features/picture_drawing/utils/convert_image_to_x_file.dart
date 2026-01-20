import 'dart:io';
import 'dart:ui' as ui;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

Future<XFile> convertImageToXFile(ui.Image image) async {
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  final pngBytes = byteData!.buffer.asUint8List();

  final tempDir = await getTemporaryDirectory();
  final filePath = '${tempDir.path}/temp_image.png';

  final file = await File(filePath).writeAsBytes(pngBytes);

  return XFile(file.path);
}
