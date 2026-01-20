import 'package:gal/gal.dart';
import 'package:injectable/injectable.dart';

import '../../domain/domain.dart';

@Singleton()
class GalleryPictureRepository {
  Future<void> save({required String path}) async {
    try {
      await Gal.putImage(path);
    } catch (error) {
      throw PictureError.saveError();
    }
  }
}
