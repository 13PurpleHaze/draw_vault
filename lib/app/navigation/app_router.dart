import 'package:injectable/injectable.dart';
import 'package:auto_route/auto_route.dart';

import 'package:draw_vault/app/navigation/app_router.gr.dart';
import 'package:draw_vault/app/navigation/guard.dart';

@Singleton()
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  final AuthGuard _authGuard;

  AppRouter(AuthGuard authGuard) : _authGuard = authGuard;
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SignInRoute.page),
    AutoRoute(page: SignUpRoute.page),
    AutoRoute(page: PictureListRoute.page, guards: [_authGuard], initial: true),
    AutoRoute(page: PictureDrawingRouteWrapper.page),
  ];
}
