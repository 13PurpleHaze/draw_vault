import 'package:flutter/material.dart';

import 'package:draw_vault/app/shared/shared.dart';

class AuthScreenLayout extends StatelessWidget {
  final List<Widget> children;
  const AuthScreenLayout({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AppScaffold(
          body: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(child: Column(children: children)),
            ),
          ),
        );
      },
    );
  }
}
