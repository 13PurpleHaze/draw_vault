import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:draw_vault/app/network/connectivly_service.dart';
import 'package:draw_vault/app/shared/shared.dart';

part 'picture_list_event.dart';
part 'picture_list_state.dart';

@Singleton()
class PictureListBloc extends Bloc<PictureListEvent, PictureListState> {
  final PictureRepository _pictureRepository;
  final ConnectivityService _connectivityService;
  late final StreamSubscription<bool> _connectivitySubscription;
  String? currentUserId;

  PictureListBloc({
    required PictureRepository pictureRepository,
    required ConnectivityService connectivityService,
  }) : _pictureRepository = pictureRepository,
       _connectivityService = connectivityService,
       super(PictureListInitial()) {
    on<LoadPictureList>(_fetch);
    on<ChangeConnection>(_changeConnection);
    _connectivitySubscription = _connectivityService.connectivityStream.listen((
      isConnected,
    ) {
      add(ChangeConnection(isConnected: isConnected));
    });
  }

  void _changeConnection(
    ChangeConnection event,
    Emitter<PictureListState> emit,
  ) {
    if (event.isConnected && currentUserId != null) {
      add(LoadPictureList(userId: currentUserId!));
    } else {
      emit(LostConnection());
    }
  }

  Future<void> _fetch(
    LoadPictureList event,
    Emitter<PictureListState> emit,
  ) async {
    try {
      emit(PictureListLoading());
      currentUserId = event.userId;
      final pictures = await _pictureRepository.fetch(userId: event.userId);
      emit(PictureListLoaded(pictures: pictures));
    } on PictureError catch (error) {
      emit(PictureListFails(message: error.message));
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}
