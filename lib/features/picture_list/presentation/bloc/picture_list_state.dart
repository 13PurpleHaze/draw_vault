part of 'picture_list_bloc.dart';

sealed class PictureListState {}

final class PictureListInitial extends PictureListState {}

final class PictureListLoading extends PictureListState {}

final class PictureListLoaded extends PictureListState {
  final List<Picture> pictures;

  PictureListLoaded({required this.pictures});
}

final class PictureListFails extends PictureListState {
  final String message;

  PictureListFails({required this.message});
}

final class LostConnection extends PictureListState {}
