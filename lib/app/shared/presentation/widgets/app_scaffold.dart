import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  const AppScaffold({super.key, required this.body, this.appBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // Scaffold не меняет размеры body при появлении клавиатуры
      appBar: appBar,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/bg.png', fit: BoxFit.cover),
          Image.asset('assets/images/bg_line.png', fit: BoxFit.cover),
          Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: body),
        ],
      ),
    );
  }
}

// Почему тут expanded? Для того чтобы передать строгие(minWidth,maxWidth) constraints для неспозиционированных элементов
// Они равны ширине и высоте экрана(тк Scaffold используем)
