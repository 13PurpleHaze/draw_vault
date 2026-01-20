import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../domain/domain.dart';

/*
  Класс для сохранения картинок в firebase. Используется firestore, а изображения хранятся в base64
*/
@Singleton()
class FirebasePictureRepository {
  static final _firebaseStore = FirebaseFirestore.instance;

  Future<List<Picture>> fetch({required String userId}) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('images')
          .where('user_id', isEqualTo: userId)
          .get();

      return querySnapshot.docs
          .map(
            (doc) => Picture(
              userId: userId,
              pictureId: doc.id,
              name: doc['image_name'],
              data: base64.decode(doc['data']),
            ),
          )
          .toList();
    } catch (error) {
      throw PictureError.fetchError();
    }
  }

  Future<Picture> fetchById({
    required String userId,
    required String pictureId,
  }) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('images')
          .doc(pictureId)
          .get();

      return Picture(
        userId: userId,
        pictureId: querySnapshot.id,
        name: querySnapshot['image_name'],
        data: base64.decode(querySnapshot['data']),
      );
    } catch (error) {
      throw PictureError.fetchError();
    }
  }

  Future<void> save({
    required String userId,
    required String name,
    required String data,
  }) async {
    try {
      await _firebaseStore.collection('images').add({
        'user_id': userId,
        'image_name': name,
        'data': data,
      });
    } catch (error) {
      throw PictureError.saveError();
    }
  }

  Future<void> update({
    required String userId,
    required String name,
    required String data,
    required String pictureId,
  }) async {
    try {
      await _firebaseStore.collection('images').doc(pictureId).update({
        'user_id': userId,
        'image_name': name,
        'data': data,
      });
    } catch (error) {
      throw PictureError.saveError();
    }
  }
}
