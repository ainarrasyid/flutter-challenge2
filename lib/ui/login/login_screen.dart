import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:challenge2/core/data/model/user.dart';
import 'package:challenge2/core/utils/shared_preferences.dart';
import 'package:challenge2/core/utils/status.dart';
import 'package:challenge2/core/utils/translation.dart';
import 'package:challenge2/core/widgets/app_button.dart';
import 'package:challenge2/core/widgets/app_colors.dart';
import 'package:challenge2/core/widgets/app_textfield.dart';
import 'package:challenge2/core/widgets/app_theme.dart';
import 'package:challenge2/ui/bloc/main_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  SharedPref sharedPref = SharedPref();
  User userLoad = const User();
  bool isLoading = false;

  TextEditingController passwordController = TextEditingController(text: '');
  TextEditingController emailController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    Widget header() {
      return Container(
        height: 210,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        decoration: const BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(48.0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.text.app_name,
              style: AppTheme()
                  .textTheme
                  .headline4
                  ?.copyWith(fontSize: 24, color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              context.text.label_please_login,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
    }

    Widget content() {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppTextField(
                title: context.text.label_email,
                hint: context.text.label_email,
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
              ),
              const SizedBox(
                height: 24,
              ),
              AppTextField(
                title: context.text.label_password,
                hint: context.text.label_password,
                keyboardType: TextInputType.visiblePassword,
                obscure: true,
                controller: passwordController,
              ),
              const SizedBox(
                height: 88,
              ),
              AppButton(
                isLoading: isLoading,
                padding: 17,
                caption: context.text.label_login,
                onPressed: () => login(),
              ),
              const SizedBox(
                height: 13,
              ),
              AppButton(
                isEnabled: !isLoading,
                color: Colors.white,
                padding: 17,
                caption: context.text.label_register,
                onPressed: () => context.push('/register'),
              ),
            ],
          ),
        ),
      );
    }

    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) {
        log(state.toString());
        if (state is TokenResultState) {
          if (state.status == Status.error) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('${state.message}')));
          }
        }

        if (state is LoginResultState) {
          if (state.status == Status.loading) {
            isLoading = true;
          } else if (state.status == Status.success) {
            isLoading = false;
            context.go('/menu');
          } else if (state.status == Status.error) {
            isLoading = false;
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message.toString())));
          }
        }
      },
      builder: (context, state) {
        return Container(
          color: AppColors.primary,
          child: SafeArea(
            bottom: false,
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: Column(
                children: [
                  header(),
                  content(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void login() {
    String? email = emailController.text;
    String? password = passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      context.read<MainBloc>().password = password;
      context.read<MainBloc>().email = email;
      BlocProvider.of<MainBloc>(context).add(const Login());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.text.label_error_empty_form)));
    }
  }
}
