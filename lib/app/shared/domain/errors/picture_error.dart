sealed class PictureError {
  const PictureError();
  const factory PictureError.fetchError() = PictureFetchError;
  const factory PictureError.saveError() = PictureSaveError;

  String get message {
    return switch (this) {
      PictureFetchError() =>
        'Не получилось загрузить изображения. Попробуйте позже',
      PictureSaveError() =>
        'Не получилось сохранить изображение. Попробуйте позже',
    };
  }
}

final class PictureFetchError extends PictureError {
  const PictureFetchError();
}

final class PictureSaveError extends PictureError {
  const PictureSaveError();
}
