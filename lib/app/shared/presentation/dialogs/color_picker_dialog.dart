import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

void showColorPicker({
  required BuildContext context,
  required Function(Color selectedColor) onColorPicked,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: ColorPicker(onColorPicked: onColorPicked),
        ),
      );
    },
  );
}
