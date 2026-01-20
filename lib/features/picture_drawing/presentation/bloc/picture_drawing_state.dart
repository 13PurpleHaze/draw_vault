part of 'picture_drawing_bloc.dart';

sealed class PictureDrawingState {}

final class PictureDrawingInitial extends PictureDrawingState {}

final class PictureDrawingLoading extends PictureDrawingState {}

final class PictureDrawingSuccess extends PictureDrawingState {}

final class PictureDrawingFails extends PictureDrawingState {
  final String message;

  PictureDrawingFails({required this.message});
}

// состояния для load картинки из firebase

final class PictureDrawingImageLoading extends PictureDrawingState {}

final class PictureDrawingImageSuccess extends PictureDrawingState {
  final LoadedPicture picture;

  PictureDrawingImageSuccess({required this.picture});
}

final class PictureDrawingImageFails extends PictureDrawingState {
  final String message;

  PictureDrawingImageFails({required this.message});
}
