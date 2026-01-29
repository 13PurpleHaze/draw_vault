import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';

import 'package:draw_vault/app/navigation/app_router.gr.dart';
import 'package:draw_vault/app/shared/presentation/widgets/widgets.dart';

import '../bloc/auth_bloc.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    final authBloc = context.read<AuthBloc>();
    authBloc.add(AuthCheckCurrentUser());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        await Future.delayed(
          const Duration(milliseconds: 100),
        ); // формально чтобы увидеть этот экран
        if (state is AuthInitial) {
          AutoRouter.of(context).replace(const SignInRoute());
        } else {
          AutoRouter.of(context).replace(const PictureListRoute());
        }
      },
      child: AppScaffold(),
    );
  }
}
