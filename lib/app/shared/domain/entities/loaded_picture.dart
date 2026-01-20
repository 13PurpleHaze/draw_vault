import 'dart:ui' as ui;

class LoadedPicture {
  final String userId;
  final String pictureId;
  final String name;
  final ui.Image picture;

  LoadedPicture({
    required this.userId,
    required this.name,
    required this.picture,
    required this.pictureId,
  });
}
