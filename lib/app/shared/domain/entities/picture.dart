import 'dart:typed_data';

class Picture {
  final String userId;
  final String pictureId;
  final String name;
  final Uint8List data;

  Picture({
    required this.userId,
    required this.name,
    required this.data,
    required this.pictureId,
  });
}
