import 'package:draw_vault/app/shared/shared.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:draw_vault/app/navigation/app_router.gr.dart';
import 'package:draw_vault/features/auth/presentation/bloc/auth_bloc.dart';

import '../bloc/picture_list_bloc.dart';

@RoutePage()
class PictureListScreen extends StatefulWidget {
  const PictureListScreen({super.key});

  @override
  State<PictureListScreen> createState() => _PictureListScreenState();
}

class _PictureListScreenState extends State<PictureListScreen> {
  @override
  void initState() {
    final user = context.read<AuthBloc>().currentUser!;
    context.read<PictureListBloc>().add(LoadPictureList(userId: user.id));
    super.initState();
  }

  Future<void> _onOpenDrawingScreen({String? pictureId}) async {
    final result = await AutoRouter.of(
      context,
    ).push<bool>(PictureDrawingRouteWrapper(pictureId: pictureId));

    if (result == true) {
      final user = context.read<AuthBloc>().currentUser!;
      context.read<PictureListBloc>().add(LoadPictureList(userId: user.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is! AuthSignOutLoading && AutoRouter.of(context).canPop()) {
          Navigator.of(context).pop();
        }
        if (state is AuthSignOutSuccess) {
          AutoRouter.of(context).replace(SplashRoute());
        }
        if (state is AuthSignOutLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Center(
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: Center(child: CupertinoActivityIndicator()),
                ),
              );
            },
          );
        }
      },
      child: AppScaffold(
        appBar: AppAppbar(
          title: 'Галерея',
          leading: IconButton(
            onPressed: () {
              showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  title: Text('Вы уверены что хотите выйти из аккаунта?'),
                  actions: [
                    CupertinoDialogAction(
                      child: Text('Да'),
                      onPressed: () =>
                          context.read<AuthBloc>().add(AuthSignOutPressed()),
                    ),
                    CupertinoDialogAction(
                      child: Text('Нет'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              );
              //
            },
            icon: Image.asset(
              'assets/icons/log_out.png',
              width: 24,
              height: 24,
            ),
          ),
        ),
        body: BlocBuilder<PictureListBloc, PictureListState>(
          builder: (context, state) {
            // В зависимости от состояния отображаем разный контент(лоадер, текст с ошибкой, текст с отстутсвием интерет соединения и тд)
            if (state is PictureListLoading) {
              return Center(child: CupertinoActivityIndicator());
            }
            if (state is PictureListFails) {
              return Center(child: Text(state.message));
            }
            if (state is LostConnection) {
              return Center(child: Text('Отсутствует интернет соединение'));
            }
            if (state is PictureListLoaded) {
              return Stack(
                children: [
                  GridView.builder(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1,
                    ),
                    itemCount: state.pictures.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          _onOpenDrawingScreen(
                            pictureId: state.pictures[index].pictureId,
                          );
                        },
                        child: Card(
                          elevation: 4,
                          clipBehavior: Clip.hardEdge,
                          child: Image.memory(
                            state.pictures[index].data,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: SafeArea(
                      top: false,
                      child: AppFieldButton(
                        onPressed: () {
                          _onOpenDrawingScreen();
                        },
                        variant: ButtonVariant.primary,
                        child: Text('Создать'),
                      ),
                    ),
                  ),
                ],
              );
            }
            return Center(child: CupertinoActivityIndicator());
          },
        ),
      ),
    );
  }
}
