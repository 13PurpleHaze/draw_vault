import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:draw_vault/app/notifications/notification_service.dart';
import 'package:draw_vault/app/shared/domain/domain.dart';

part 'picture_drawing_event.dart';
part 'picture_drawing_state.dart';

@Injectable()
class PictureDrawingBloc
    extends Bloc<PictureDrawingEvent, PictureDrawingState> {
  final PictureRepository _pictureRepository;
  final NotificationService _notificationService;

  PictureDrawingBloc({
    required PictureRepository pictureRepository,
    required NotificationService notificationService,
  }) : _pictureRepository = pictureRepository,
       _notificationService = notificationService,
       super(PictureDrawingInitial()) {
    on<SavePicturePressed>(_savePicture);
    on<UpdatePicturePressed>(_updatePicture);
    on<LoadPictureImageDrawing>(_loadPicture);
  }

  Future<void> _savePicture(
    SavePicturePressed event,
    Emitter<PictureDrawingState> emit,
  ) async {
    try {
      emit(PictureDrawingLoading());
      await _pictureRepository.save(
        userId: event.userId,
        name: event.name,
        data: event.data,
        path: event.path,
      );
      emit(PictureDrawingSuccess());
      _notificationService.showNotification(
        id: 1,
        title: 'Изображение сохранено',
        body: 'Ваше изображение было успешно сохранено.',
      );
    } on PictureError catch (error) {
      emit(PictureDrawingFails(message: error.message));
    }
  }

  Future<void> _updatePicture(
    UpdatePicturePressed event,
    Emitter<PictureDrawingState> emit,
  ) async {
    try {
      emit(PictureDrawingLoading());
      await _pictureRepository.update(
        userId: event.userId,
        name: event.name,
        data: event.data,
        path: event.path,
        pictureId: event.pictureId,
      );
      emit(PictureDrawingSuccess());
      _notificationService.showNotification(
        id: 1,
        title: 'Изображение обновлено',
        body: 'Ваше изображение было успешно обновлено.',
      );
    } on PictureError catch (error) {
      emit(PictureDrawingFails(message: error.message));
    }
  }

  Future<void> _loadPicture(
    LoadPictureImageDrawing event,
    Emitter<PictureDrawingState> emit,
  ) async {
    try {
      emit(PictureDrawingImageLoading());
      final picture = await _pictureRepository.fetchById(
        userId: event.userId,
        pictureId: event.pictureId,
      );
      emit(PictureDrawingImageSuccess(picture: picture));
    } on PictureError catch (error) {
      emit(PictureDrawingFails(message: error.message));
    }
  }
}
