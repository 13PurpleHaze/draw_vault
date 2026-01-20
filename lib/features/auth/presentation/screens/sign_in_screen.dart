import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';

import 'package:draw_vault/app/navigation/app_router.gr.dart';
import 'package:draw_vault/app/shared/shared.dart';

import '../bloc/auth_bloc.dart';
import '../../utils/utils.dart';
import '../widgets/widgets.dart';

@RoutePage()
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isFormValid = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        /*
          В зависимости от состояния авторизации
           - показываем лоадер - чтобы пользователь не смог ни на что нажать
           - показываем alert при ошибке
           - уходим с экрана при успешной авторизации
        */
        if (state is AuthSignInLoading) {
          showDialog(
            context: context,
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
        if (Navigator.of(context).canPop() &&
            (state is AuthSignInFailure || state is AuthSignInSuccess)) {
          Navigator.of(context).pop();
        }
        if (state is AuthSignInFailure) {
          showAlert(context: context, title: 'Ошибка', message: state.message);
        }
        if (state is AuthSignInSuccess) {
          AutoRouter.of(context).replace(PictureListRoute());
        }
      },
      builder: (context, state) {
        return AuthScreenLayout(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                onChanged: () => setState(
                  () =>
                      _isFormValid = _formKey.currentState?.validate() ?? true,
                ),
                autovalidateMode: AutovalidateMode.onUnfocus,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Image.asset('assets/images/login_title.png'),
                    ),
                    SizedBox(height: 20),
                    AuthTextField(
                      hintText: 'Введите электронную почту',
                      labelText: 'e-mail',
                      controller: _emailController,
                      validator: emailValidator,
                    ),
                    SizedBox(height: 20),
                    AuthTextField(
                      hintText: 'Введите пароль',
                      labelText: 'Пароль',
                      obscureText: true,
                      controller: _passwordController,
                      validator: passwordValidator,
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Column(
                children: [
                  AppFieldButton(
                    variant: ButtonVariant.primary,
                    onPressed: () {
                      context.read<AuthBloc>().add(
                        AuthSignInPressed(
                          email: _emailController.text,
                          password: _passwordController.text,
                        ),
                      );
                    },
                    disabled: !_isFormValid,
                    child: Text('Войти'),
                  ),
                  SizedBox(height: 20),
                  AppFieldButton(
                    variant: ButtonVariant.secondary,
                    onPressed: () {
                      AutoRouter.of(context).push(SignUpRoute());
                    },
                    child: Text('Регистрация'),
                  ),
                  if (MediaQuery.of(context).viewInsets.bottom != 0)
                    SizedBox(
                      height: MediaQuery.of(context).viewInsets.bottom + 20,
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

/* 
  Небольшое пояснение по верстке(IntrinsicHeight и LayoutBuilder):
  LayoutBuilder дает возможность получить constraints в runtime, они равны в данном случае высоте экрана и ширине экрана(тк Scaffold)
  Далее они через ConstraintedBox передаются для колонки
  В итоге колонка получает ограничения по высоте: высота_экрана...бесконечность
  IntrinsicHeight заставляет Column вычислить естественную высоту и быть такого размера, как его содержимое
  Это ограничение в сочетании с ограничениями ConstrainedBox, гарантирует, 
  что столбец станет либо размером с область просмотра, либо размером с содержимое, в зависимости от того, 
  какой размер больше.

  в итоге колонка размером с экран получается + скролится если экран маленький
*/
