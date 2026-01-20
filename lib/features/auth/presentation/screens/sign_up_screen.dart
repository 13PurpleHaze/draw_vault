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
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isFormValid = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSignUpLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
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
            (state is AuthSignUpFailure || state is AuthSignUpSuccess)) {
          Navigator.of(context).pop();
        }
        if (state is AuthSignUpFailure) {
          showAlert(context: context, title: 'Ошибка', message: state.message);
        }
        if (state is AuthSignUpSuccess) {
          AutoRouter.of(context).replace(PictureListRoute());
        }
      },
      builder: (context, state) {
        return AuthScreenLayout(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUnfocus,
                onChanged: () => setState(
                  () =>
                      _isFormValid = _formKey.currentState?.validate() ?? true,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Image.asset('assets/images/login_title.png'),
                    ),
                    SizedBox(height: 20),
                    AuthTextField(
                      hintText: 'Введите ваше имя',
                      labelText: 'Имя',
                      controller: _nameController,
                      validator: nameValidator,
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
                      labelText: '8-16 символов',
                      obscureText: true,
                      controller: _passwordController,
                      validator: passwordValidator,
                    ),
                    SizedBox(height: 20),
                    AuthTextField(
                      hintText: 'Введите пароль',
                      labelText: 'Подтверждение пароля',
                      obscureText: true,
                      controller: _confirmPasswordController,
                      validator: confirmPasswordValidator(_passwordController),
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
                    variant: ButtonVariant.secondary,
                    onPressed: () {
                      context.read<AuthBloc>().add(
                        AuthSignUpPressed(
                          name: _nameController.text,
                          email: _emailController.text,
                          password: _passwordController.text,
                        ),
                      );
                    },
                    disabled: !_isFormValid,
                    child: Text('Зарегистрироваться'),
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
