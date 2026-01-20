import 'package:flutter/material.dart';

class ColorPicker extends StatefulWidget {
  final void Function(Color selectedColor) onColorPicked;

  const ColorPicker({super.key, required this.onColorPicked});

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  List<Color> _generateColorGrid(int rows, int columns) {
    List<Color> colors = List.generate(rows * columns, (index) => Colors.black);

    final x = 255 ~/ (columns - 1);

    for (int col = 0; col < columns; col++) {
      final value = 255 - x * col;
      colors[col] = Color.fromRGBO(value, value, value, 1);
    }

    for (int col = 0; col < columns; col++) {
      Color baseColor = _getBaseColor(col);

      for (int row = 1; row < rows; row++) {
        int shadeFactor = (row * (255 ~/ (rows - 1))) ~/ 1.2;

        colors[columns * row + col] = Color.fromARGB(
          255,
          (baseColor.red + shadeFactor).clamp(0, 255),
          (baseColor.green + shadeFactor).clamp(0, 255),
          (baseColor.blue + shadeFactor).clamp(0, 255),
        );
      }
    }
    return colors;
  }

  Color _getBaseColor(int col) {
    switch (col) {
      case 0:
        return Color.fromRGBO(0, 55, 74, 1);
      case 1:
        return Color.fromRGBO(1, 29, 87, 1);
      case 2:
        return Color.fromRGBO(17, 5, 59, 1);
      case 3:
        return Color.fromRGBO(46, 6, 61, 1);
      case 4:
        return Color.fromRGBO(60, 7, 27, 1);
      case 5:
        return Color.fromRGBO(92, 7, 1, 1);
      case 6:
        return Color.fromRGBO(90, 528, 0, 1);
      case 7:
        return Color.fromRGBO(88, 51, 0, 1);
      case 8:
        return Color.fromRGBO(86, 61, 0, 1);
      case 9:
        return Color.fromRGBO(102, 97, 0, 1);
      case 10:
        return Color.fromRGBO(79, 85, 4, 1);
      case 11:
        return Color.fromRGBO(38, 62, 15, 1);
      default:
        return Color.fromRGBO(0, 55, 74, 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Color> colors = _generateColorGrid(10, 12);
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 12,
        childAspectRatio: 1,
      ),
      itemCount: colors.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            widget.onColorPicked(colors[index]);
            Navigator.of(context).pop();
          },
          child: Container(color: colors[index]),
        );
      },
    );
  }
}
