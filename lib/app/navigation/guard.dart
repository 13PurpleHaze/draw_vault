import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:draw_vault/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:draw_vault/features/auth/domain/domain.dart';

import 'package:draw_vault/app/navigation/app_router.gr.dart';

@Singleton()
class AuthGuard extends AutoRouteGuard {
  final AuthRepository _authRepo;
  final AuthBloc _authBloc;

  AuthGuard({required AuthRepository authRepo, required AuthBloc authBloc})
    : _authRepo = authRepo,
      _authBloc = authBloc;

  @override
  FutureOr<void> onNavigation(NavigationResolver resolver, StackRouter router) {
    final user = _authRepo.currentUser;
    if (user != null) {
      _authBloc.add(AuthStartAuthenticated(user: user));
      resolver.next();
    } else {
      router.replace(const SignInRoute());
    }
  }
}
