import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

void showStroke({
  required BuildContext context,
  required double currentWidth,
  required bool isEraser,
  required Color currentColor,
  required ValueChanged<double> onWidthSelected,
}) {
  showDialog(
    context: context,
    builder: (context) {
      double tempWidth = currentWidth;

      return Dialog(
        child: StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Толщина линии',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        width: tempWidth,
                        height: tempWidth,
                        decoration: BoxDecoration(
                          color: isEraser ? Colors.grey : currentColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Slider(
                          min: 1,
                          max: 30,
                          value: tempWidth,
                          onChanged: (value) {
                            setModalState(() => tempWidth = value);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: AppFieldButton(
                      variant: ButtonVariant.primary,
                      child: const Text('Готово'),
                      onPressed: () {
                        onWidthSelected(tempWidth);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
