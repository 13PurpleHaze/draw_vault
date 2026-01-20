import 'package:flutter/material.dart';

// Расширение для градента главной кнопки, чтобы настраивать ее через тему, а не в кнопке
class AppGradients extends ThemeExtension<AppGradients> {
  final List<Color> primaryButton;

  const AppGradients({required this.primaryButton});

  @override
  AppGradients copyWith({List<Color>? primaryButton}) {
    return AppGradients(primaryButton: primaryButton ?? this.primaryButton);
  }

  @override
  AppGradients lerp(ThemeExtension<AppGradients>? other, double t) {
    if (other is! AppGradients) return this;
    return AppGradients(
      primaryButton: List.generate(
        primaryButton.length,
        (i) =>
            Color.lerp(primaryButton[i], other.primaryButton[i], t) ??
            primaryButton[i],
      ),
    );
  }
}
