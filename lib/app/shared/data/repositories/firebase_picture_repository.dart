import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../domain/domain.dart';

/*
  Класс для сохранения картинок в firebase. Используется firestore, а изображения хранятся в base64,
  разделенные на чанки, чтобы была возможность хранить большие изображения(больше чем > 1мб)
*/

const chunkSize = 800000;

@Singleton()
class FirebasePictureRepository {
  static final _firebaseStore = FirebaseFirestore.instance;

  /*
    Получаем сначала все картинки пользователя из коллекции images
    Затем в подколлекции берем чанки и соединяем их в одну строку base64
    Ну и сам метод возвращяет наш класс из domain Picture
  */
  Future<List<Picture>> fetch({required String userId}) async {
    try {
      final querySnapshot = await _firebaseStore
          .collection('images')
          .where('user_id', isEqualTo: userId)
          .get();

      final pictures = <Picture>[];

      for (var doc in querySnapshot.docs) {
        final chunkSnapshot = await doc.reference
            .collection('chunks')
            .orderBy(FieldPath.documentId)
            .get();

        final base64String = chunkSnapshot.docs
            .map((d) => d['data'] as String)
            .join();
        pictures.add(
          Picture(
            userId: userId,
            pictureId: doc.id,
            name: doc['image_name'],
            data: base64.decode(base64String),
          ),
        );
      }

      return pictures;
    } catch (error) {
      throw PictureError.fetchError();
    }
  }

  Future<Picture> fetchById({
    required String userId,
    required String pictureId,
  }) async {
    try {
      final docRef = _firebaseStore.collection('images').doc(pictureId);
      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) throw PictureError.fetchError();

      final chunkSnapshot = await docRef
          .collection('chunks')
          .orderBy(FieldPath.documentId)
          .get();

      final base64String = chunkSnapshot.docs
          .map((d) => d['data'] as String)
          .join();

      return Picture(
        userId: userId,
        pictureId: docSnapshot.id,
        name: docSnapshot['image_name'],
        data: base64.decode(base64String),
      );
    } catch (error) {
      throw PictureError.fetchError();
    }
  }

  /*
    Сначала делим base64 строку на чанки, уместимого размера
    Затем сохраняем данные об изображении(название, пользователь, кол-во чанков)
    Затем сохраняем чанки в подколекцию, назначем им id(с ведущими нулями, с ними все документы сортируются правильно)
  */
  Future<void> save({
    required String userId,
    required String name,
    required String data,
  }) async {
    try {
      final chunks = <String>[];

      for (int i = 0; i < data.length; i += chunkSize) {
        int end = (i + chunkSize < data.length) ? i + chunkSize : data.length;
        chunks.add(data.substring(i, end));
      }

      final docRef = await _firebaseStore.collection('images').add({
        'user_id': userId,
        'image_name': name,
        'total_chunks': chunks.length,
      });

      final chunksCollection = docRef.collection('chunks');
      for (int i = 0; i < chunks.length; i++) {
        final chunkId = 'chunk_${i.toString().padLeft(3, '0')}';
        await chunksCollection.doc(chunkId).set({'data': chunks[i]});
      }
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
      final int chunkSize = 800000;
      final chunks = <String>[];

      for (int i = 0; i < data.length; i += chunkSize) {
        int end = (i + chunkSize < data.length) ? i + chunkSize : data.length;
        chunks.add(data.substring(i, end));
      }

      final docRef = _firebaseStore.collection('images').doc(pictureId);

      await docRef.update({
        'user_id': userId,
        'image_name': name,
        'total_chunks': chunks.length,
      });

      final oldChunks = await docRef.collection('chunks').get();
      for (var doc in oldChunks.docs) {
        await doc.reference.delete();
      }

      final chunksCollection = docRef.collection('chunks');
      for (int i = 0; i < chunks.length; i++) {
        await chunksCollection.doc('chunk_${i.toString().padLeft(3, '0')}').set(
          {'data': chunks[i]},
        );
      }
    } catch (error) {
      throw PictureError.saveError();
    }
  }
}
