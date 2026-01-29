import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

import 'package:draw_vault/app/shared/shared.dart';
import 'package:draw_vault/features/auth/presentation/bloc/auth_bloc.dart';

import '../bloc/picture_drawing_bloc.dart';
import '../widgets/widgets.dart';
import '../../utils/utils.dart';
import '../dialogs/dialogs.dart';

/*
  Решил для создания и для регистрации использовать 1 экран, тк они практически полностью эдентичны
*/
class PictureDrawingScreen extends StatefulWidget {
  final String? pictureId;

  const PictureDrawingScreen({super.key, this.pictureId});

  @override
  State<PictureDrawingScreen> createState() => _PictureDrawingScreenState();
}

class _PictureDrawingScreenState extends State<PictureDrawingScreen> {
  final picker = ImagePicker();
  // Состояния для редактирования канваса
  final List<Stroke> strokes = [];
  Color currentColor = Colors.black;
  double currentWidth = 4;
  bool isEraser = false;

  ui.Image?
  image; // Нужен чтобы после того как выбрали изображение нарисовать его на канвасе
  GlobalKey canvasKey =
      GlobalKey(); // нужен чтобы из канваса сделать изображение
  double? aspectRatio;

  @override
  void initState() {
    super.initState();
    if (widget.pictureId != null) {
      final user = context.read<AuthBloc>().currentUser!;
      context.read<PictureDrawingBloc>().add(
        LoadPictureImageDrawing(userId: user.id, pictureId: widget.pictureId!),
      );
    }
    // Фиксируем aspectRation, либо альбомная ореинтация либо портретная
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final choice = await showCanvasAspectRatioDialog(context);
      if (choice != null) {
        if (choice == 'Landscape') {
          setState(() {
            aspectRatio = 16 / 9;
          });
        } else {
          setState(() {
            aspectRatio = 9 / 16;
          });
        }
      }
    });
  }

  Future<void> _onPickImagePressed() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final pickedImage = await convertXFileToImage(pickedFile);
      setState(() {
        image = pickedImage;
      });
    }
  }

  /*
    captureImage - из канваса в ui.Image
    convertImageToXFile - из ui.Image в файл чтобы потом сохранить в галерею
  */
  Future<void> _onShareToGalleryPressed(BuildContext context) async {
    final image = await captureImage(canvasKey: canvasKey);
    final xfile = await convertImageToXFile(image);
    final box = context.findRenderObject() as RenderBox?;
    SharePlus.instance.share(
      ShareParams(
        files: [xfile],
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      ),
    );
  }

  Future<void> _onSavePressed(BuildContext context) async {
    final capturedImage = await captureImage(canvasKey: canvasKey);
    final xfile = await convertImageToXFile(capturedImage);

    // Получаем нужные для сохранения значения - userId, название, data
    final user = context.read<AuthBloc>().currentUser!;
    final bytes = await xfile.readAsBytes();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final name = 'drawing_$timestamp.png';

    final base64Image = base64Encode(bytes);

    setState(() {
      image = capturedImage;
    });
    if (widget.pictureId != null) {
      context.read<PictureDrawingBloc>().add(
        UpdatePicturePressed(
          userId: user.id,
          name: name,
          data: base64Image,
          path: xfile.path,
          pictureId: widget.pictureId!,
        ),
      );
    } else {
      context.read<PictureDrawingBloc>().add(
        SavePicturePressed(
          userId: user.id,
          name: name,
          data: base64Image,
          path: xfile.path,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppAppbar(
        title: widget.pictureId != null
            ? 'Редактирование'
            : 'Новое изображение',
        actions: [
          IconButton(
            onPressed: () {
              _onSavePressed(context);
            },
            icon: Image.asset('assets/icons/ok.png'),
          ),
        ],
      ),
      body: BlocConsumer<PictureDrawingBloc, PictureDrawingState>(
        listener: (context, state) {
          if (AutoRouter.of(context).canPop() && state is PictureDrawingFails ||
              state is PictureDrawingSuccess) {
            Navigator.of(context).pop();
          }
          if (state is PictureDrawingFails) {
            showAlert(
              context: context,
              title: 'Ошибка',
              message: state.message,
            );
          }
          if (state is PictureDrawingSuccess) {
            AutoRouter.of(context).pop(true);
          }
          if (state is PictureDrawingLoading) {
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
        builder: (context, state) {
          if (state is PictureDrawingImageLoading) {
            return Center(child: CupertinoActivityIndicator());
          }
          if (state is PictureDrawingImageFails) {
            return Center(
              child: Text(
                'Не получислось загрущить изображение попробуйте позже',
              ),
            );
          }
          return SafeArea(
            child: Column(
              children: [
                SizedBox(height: 16),
                CanvasActions(
                  currentWidth: currentWidth,
                  currentColor: currentColor,
                  isEraser: isEraser,
                  onPickImagePressed: _onPickImagePressed,
                  onShareToGalleryPressed: (BuildContext context) {
                    _onShareToGalleryPressed(context);
                  },
                  onEraserPressed: () {
                    setState(() {
                      isEraser = !isEraser;
                    });
                  },
                  onWidthPressed: (newWidth) {
                    setState(() {
                      currentWidth = newWidth;
                    });
                  },
                  onColorPicked: (pickedColor) {
                    setState(() {
                      currentColor = pickedColor;
                    });
                  },
                ),
                SizedBox(height: 16),
                Expanded(
                  child: Center(
                    child: aspectRatio != null
                        ? AspectRatio(
                            aspectRatio: aspectRatio!,
                            child: Canvas(
                              canvasKey: canvasKey,
                              currentColor: currentColor,
                              currentWidth: currentWidth,
                              isEraser: isEraser,
                              image:
                                  image ??
                                  (state is PictureDrawingImageSuccess
                                      ? state.picture.picture
                                      : null),
                            ),
                          )
                        : Canvas(
                            canvasKey: canvasKey,
                            currentColor: currentColor,
                            currentWidth: currentWidth,
                            isEraser: isEraser,
                            image:
                                image ??
                                (state is PictureDrawingImageSuccess
                                    ? state.picture.picture
                                    : null),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
