import 'package:injectable/injectable.dart';
import 'package:auto_route/auto_route.dart';

import 'package:draw_vault/app/navigation/app_router.gr.dart';

@Singleton()
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    CustomRoute(
      page: SignInRoute.page,
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    CustomRoute(
      page: PictureListRoute.page,
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    AutoRoute(page: SignUpRoute.page),
    AutoRoute(page: PictureDrawingRouteWrapper.page),
  ];
}
