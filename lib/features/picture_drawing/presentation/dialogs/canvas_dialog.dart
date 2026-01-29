import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<String?> showCanvasAspectRatioDialog(BuildContext context) async {
  return showCupertinoDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text('Выберите соотношение сторон холста'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop('Portrait'),
            child: Text('Портретное'),
          ),
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop('Landscape'),
            child: Text('Альбомное'),
          ),
        ],
      );
    },
  );
}
