import 'package:flutter/cupertino.dart';

String? emailValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Введите email';
  }

  final emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  if (!emailRegex.hasMatch(value)) {
    return 'Некорректный формат email';
  }

  return null;
}

String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Введите пароль';
  }

  if (value.length < 8) {
    return 'Пароль должен быть не менее 8 символов';
  }

  return null;
}

String? Function(String?) confirmPasswordValidator(
  TextEditingController passwordController,
) {
  return (String? value) {
    if (value == null || value.isEmpty) {
      return 'Подтвердите пароль';
    }
    if (value != passwordController.text) {
      return 'Пароли не совпадают';
    }
    return null;
  };
}

String? nameValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Введите имя';
  }
  if (value.length < 3) {
    return 'Имя должно быть не менее 3 символов';
  }

  return null;
}
