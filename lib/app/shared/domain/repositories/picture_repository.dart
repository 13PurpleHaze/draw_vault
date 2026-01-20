import '../entities/entities.dart';

abstract class PictureRepository {
  Future<List<Picture>> fetch({required String userId});
  Future<LoadedPicture> fetchById({
    required String userId,
    required String pictureId,
  });

  Future<void> save({
    required String userId,
    required String name,
    required String data,
    required String path,
  });
  Future<void> update({
    required String userId,
    required String name,
    required String data,
    required String path,
    required String pictureId,
  });
}
