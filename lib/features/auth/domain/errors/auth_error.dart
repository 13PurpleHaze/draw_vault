sealed class AuthError {
  const AuthError();

  const factory AuthError.invalidCredentials() = InvalidCredentials;
  const factory AuthError.userNotFound() = UserNotFound;
  const factory AuthError.wrongPassword() = WrongPassword;
  const factory AuthError.emailAlreadyInUse() = EmailAlreadyInUse;
  const factory AuthError.weakPassword() = WeakPassword;
  const factory AuthError.serverError() = ServerError;

  String get message {
    return switch (this) {
      InvalidCredentials() => 'Некоректные email и пароль',
      UserNotFound() => 'Пользователь не найден',
      WrongPassword() => 'Невреный пароль',
      EmailAlreadyInUse() => 'Email уже используется',
      WeakPassword() => 'Слабый пароль',
      ServerError() => 'Ошибка сервера, попробуйте позже',
    };
  }
}

class InvalidCredentials extends AuthError {
  const InvalidCredentials();
}

class UserNotFound extends AuthError {
  const UserNotFound();
}

class WrongPassword extends AuthError {
  const WrongPassword();
}

class EmailAlreadyInUse extends AuthError {
  const EmailAlreadyInUse();
}

class WeakPassword extends AuthError {
  const WeakPassword();
}

class ServerError extends AuthError {
  const ServerError();
}
