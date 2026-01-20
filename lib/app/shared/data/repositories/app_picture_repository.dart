import 'package:injectable/injectable.dart';

import '../../domain/domain.dart';
import '../../utils/utils.dart';
import './firebase_picture_repository.dart';
import './gallery_picture_repository.dart';

/*
  Репозиторий, который совмещяет работу и firebase и local
*/
@Injectable(as: PictureRepository)
class AppPictureRepository extends PictureRepository {
  final GalleryPictureRepository _galleryPictureRepository;
  final FirebasePictureRepository _firebasePictureRepository;

  AppPictureRepository({
    required GalleryPictureRepository galleryPictureRepository,
    required FirebasePictureRepository firebasePictureRepository,
  }) : _galleryPictureRepository = galleryPictureRepository,
       _firebasePictureRepository = firebasePictureRepository;

  @override
  Future<List<Picture>> fetch({required String userId}) async {
    return await _firebasePictureRepository.fetch(userId: userId);
  }

  @override
  Future<void> save({
    required String userId,
    required String name,
    required String data,
    required String path,
  }) async {
    await _firebasePictureRepository.save(
      userId: userId,
      name: name,
      data: data,
    );
    await _galleryPictureRepository.save(path: path);
  }

  @override
  Future<void> update({
    required String userId,
    required String name,
    required String data,
    required String path,
    required String pictureId,
  }) async {
    await _firebasePictureRepository.update(
      userId: userId,
      name: name,
      data: data,
      pictureId: pictureId,
    );
    await _galleryPictureRepository.save(path: path);
  }

  @override
  Future<LoadedPicture> fetchById({
    required String userId,
    required String pictureId,
  }) async {
    final picture = await _firebasePictureRepository.fetchById(
      userId: userId,
      pictureId: pictureId,
    );
    final pictureImage = await convertUint8ListToImage(picture.data);
    return LoadedPicture(
      userId: picture.userId,
      name: picture.name,
      picture: pictureImage,
      pictureId: pictureId,
    );
  }
}
