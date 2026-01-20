import '../entities/entities.dart';

abstract class AuthRepository {
  Future<void> signIn({required String email, required String password});

  Future<void> signUp({required String email, required String password});

  Future<void> updateName({required String name});

  Future<void> signOut();

  AppUser? get currentUser;
}
