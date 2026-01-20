part of 'picture_drawing_bloc.dart';

sealed class PictureDrawingEvent {}

final class SavePicturePressed extends PictureDrawingEvent {
  final String userId;
  final String name;
  final String data;
  final String path;

  SavePicturePressed({
    required this.userId,
    required this.name,
    required this.data,
    required this.path,
  });
}

final class LoadPictureImageDrawing extends PictureDrawingEvent {
  final String userId;
  final String pictureId;

  LoadPictureImageDrawing({required this.userId, required this.pictureId});
}

final class UpdatePicturePressed extends PictureDrawingEvent {
  final String userId;
  final String name;
  final String data;
  final String path;
  final String pictureId;

  UpdatePicturePressed({
    required this.userId,
    required this.name,
    required this.data,
    required this.path,
    required this.pictureId,
  });
}
