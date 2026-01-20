import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';

import 'package:draw_vault/app/di/di.dart';

import '../bloc/picture_drawing_bloc.dart';
import './picture_drawing_screen.dart';

@RoutePage()
class PictureDrawingScreenWrapper extends StatelessWidget {
  final String? pictureId;

  const PictureDrawingScreenWrapper({super.key, this.pictureId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PictureDrawingBloc>(
      create: (context) => getIt<PictureDrawingBloc>(),
      child: PictureDrawingScreen(pictureId: pictureId),
    );
  }
}
