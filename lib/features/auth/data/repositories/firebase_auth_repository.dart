import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../domain/domain.dart';

@Injectable(as: AuthRepository)
class FirebaseAuthRepository extends AuthRepository {
  // TODO: передавать как параметр конструктора
  static final _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // маплю ошибки Firebase на свои чтобы была возможность выводить кастомные сообщения
      // на самом деле встречал только 'invalid-credential' ошибку остальные оставил для надежности
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        throw AuthError.emailAlreadyInUse();
      }
      if (error.code == 'invalid-credential') {
        throw AuthError.invalidCredentials();
      }
      if (error.code == 'user-not-found') {
        throw AuthError.userNotFound();
      }
      if (error.code == 'wrong-password') {
        throw AuthError.wrongPassword();
      }
      if (error.code == 'weak-password') {
        throw AuthError.weakPassword();
      }
      throw AuthError.serverError();
    } catch (error) {
      throw AuthError.serverError();
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (error) {
      throw AuthError.serverError();
    }
  }

  @override
  Future<void> signUp({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        throw AuthError.emailAlreadyInUse();
      }
      if (error.code == 'invalid-credentials') {
        throw AuthError.invalidCredentials();
      }
      if (error.code == 'user-not-found') {
        throw AuthError.userNotFound();
      }
      if (error.code == 'wrong-password') {
        throw AuthError.wrongPassword();
      }
      if (error.code == 'weak-password') {
        throw AuthError.weakPassword();
      }
      throw AuthError.serverError();
    } catch (error) {
      throw AuthError.serverError();
    }
  }

  @override
  AppUser? get currentUser {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    return AppUser(
      email: user.email ?? '',
      name: user.displayName ?? '',
      id: user.uid,
    );
  }

  @override
  Future<void> updateName({required String name}) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.updateDisplayName(name);
      await user.reload();
    }
  }
}
