import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/domain.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@Singleton()
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(AuthInitial()) {
    on<AuthSignInPressed>(_signIn);
    on<AuthSignOutPressed>(_signOut);
    on<AuthSignUpPressed>(_signUp);
    on<AuthStartAuthenticated>(_startAuthenticated);
  }

  void _startAuthenticated(
    AuthStartAuthenticated event,
    Emitter<AuthState> emit,
  ) {
    emit(AuthSuccess(user: event.user));
  }

  AppUser? get currentUser {
    final state = this.state;
    return state is AuthSuccess ? state.user : null;
  }

  Future<void> _signIn(AuthSignInPressed event, Emitter<AuthState> emit) async {
    try {
      emit(AuthSignInLoading());

      if (event.email.isEmpty || event.password.isEmpty) return;
      await _authRepository.signIn(
        email: event.email,
        password: event.password,
      );
      final user = _authRepository.currentUser;
      if (user != null) {
        emit(AuthSignInSuccess(user: user));
      } else {
        emit(AuthSignInFailure(message: 'Ошибка авторизации'));
      }
    } on AuthError catch (error) {
      emit(AuthSignInFailure(message: error.message));
    }
  }

  Future<void> _signUp(AuthSignUpPressed event, Emitter<AuthState> emit) async {
    try {
      emit(AuthSignUpLoading());
      await _authRepository.signUp(
        email: event.email,
        password: event.password,
      );
      final user = _authRepository.currentUser;
      if (user != null) {
        await _authRepository.updateName(name: event.name);
        emit(AuthSignUpSuccess(user: user));
      } else {
        emit(AuthSignUpFailure(message: 'Ошибка авторизации'));
      }
    } on AuthError catch (error) {
      emit(AuthSignUpFailure(message: error.message));
    }
  }

  Future<void> _signOut(
    AuthSignOutPressed event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthSignOutLoading());
      await _authRepository.signOut();
      emit(AuthSignOutSuccess());
    } on AuthError catch (error) {
      emit(AuthSignOutFailure(message: error.message));
    }
  }
}
