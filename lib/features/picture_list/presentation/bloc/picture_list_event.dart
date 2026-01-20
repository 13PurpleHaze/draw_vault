part of 'picture_list_bloc.dart';

sealed class PictureListEvent {}

final class LoadPictureList extends PictureListEvent {
  final String userId;

  LoadPictureList({required this.userId});
}

final class ChangeConnection extends PictureListEvent {
  final bool isConnected;

  ChangeConnection({required this.isConnected});
}
