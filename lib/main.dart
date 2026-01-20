import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:draw_vault/app/notifications/notification_service.dart';
import 'package:draw_vault/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:draw_vault/features/picture_list/presentation/bloc/picture_list_bloc.dart';

import 'package:draw_vault/app/di/di.dart';
import 'package:draw_vault/app/navigation/app_router.dart';
import 'package:draw_vault/app/theme/theme.dart';
import 'package:draw_vault/firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  configureDependencies();
  getIt.get<NotificationService>().init();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  final _appRouter = getIt<AppRouter>();

  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Оба блока нужны в нескольких местах поэтому глобально их провайжу
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) {
            return getIt.get<AuthBloc>();
          },
        ),
        BlocProvider<PictureListBloc>(
          create: (context) {
            return getIt.get<PictureListBloc>();
          },
        ),
      ],
      child: MaterialApp.router(
        theme: theme,
        routerConfig: _appRouter.config(),
      ),
    );
  }
}
