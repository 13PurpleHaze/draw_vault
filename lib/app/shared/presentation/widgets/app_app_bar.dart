import 'dart:ui';

import 'package:flutter/material.dart';

class AppAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  const AppAppbar({super.key, required this.title, this.leading, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: leading,

      flexibleSpace: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(196, 196, 196, 0.01),
                    blurRadius: 68,
                  ),
                  BoxShadow(
                    color: Color.fromRGBO(96, 68, 144, 0.3),
                    blurRadius: 68,
                  ),
                  BoxShadow(
                    color: Color.fromRGBO(227, 227, 227, 0.2),
                    blurRadius: 40,
                    offset: Offset(0, 1),
                    spreadRadius: -64,
                  ),
                ],
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
              child: Container(color: Colors.transparent),
            ),
          ],
        ),
      ),
      actions: actions,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
