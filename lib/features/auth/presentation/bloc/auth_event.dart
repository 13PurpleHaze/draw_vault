part of 'auth_bloc.dart';

sealed class AuthEvent {}

final class AuthSignInPressed extends AuthEvent {
  final String email;
  final String password;

  AuthSignInPressed({required this.email, required this.password});
}

final class AuthSignUpPressed extends AuthEvent {
  final String name;
  final String email;
  final String password;

  AuthSignUpPressed({
    required this.name,
    required this.email,
    required this.password,
  });
}

final class AuthSignOutPressed extends AuthEvent {}

final class AuthCheckCurrentUser extends AuthEvent {}
