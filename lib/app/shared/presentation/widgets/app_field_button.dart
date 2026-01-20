import 'package:draw_vault/app/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

enum ButtonVariant { primary, secondary }

class AppFieldButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final bool disabled;
  final Widget child;

  const AppFieldButton({
    super.key,
    required this.child,
    required this.variant,
    this.onPressed,
    this.disabled = false,
  });

  BoxDecoration _decoration(BuildContext context) {
    return switch (variant) {
      ButtonVariant.primary => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors:
              Theme.of(context).extension<AppGradients>()?.primaryButton ?? [],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      ButtonVariant.secondary => BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
    };
  }

  Color _textColor(BuildContext context) {
    final theme = Theme.of(context);

    return switch (variant) {
      ButtonVariant.primary => theme.colorScheme.onPrimary,
      ButtonVariant.secondary => theme.colorScheme.onSecondary,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        children: [
          Ink(
            decoration: _decoration(context),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: disabled ? null : onPressed,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: DefaultTextStyle(
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: _textColor(context),
                  ),
                  child: Center(child: child),
                ),
              ),
            ),
          ),
          if (disabled)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).iconTheme.color?.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
