part of 'auth_bloc.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

// states для экрана логина
final class AuthSignInLoading extends AuthState {}

final class AuthSignInSuccess extends AuthState {
  final AppUser user;

  AuthSignInSuccess({required this.user});
}

final class AuthSignInFailure extends AuthState {
  final String message;

  AuthSignInFailure({required this.message});
}

// states для экрана регистрации
final class AuthSignUpLoading extends AuthState {}

final class AuthSignUpSuccess extends AuthState {
  final AppUser user;

  AuthSignUpSuccess({required this.user});
}

final class AuthSignUpFailure extends AuthState {
  final String message;

  AuthSignUpFailure({required this.message});
}

// states для логаута

final class AuthSignOutLoading extends AuthState {}

final class AuthSignOutSuccess extends AuthState {}

final class AuthSignOutFailure extends AuthState {
  final String message;

  AuthSignOutFailure({required this.message});
}

// общие states
final class AuthSuccess extends AuthState {
  final AppUser user;

  AuthSuccess({required this.user});
}
