import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:challenge2/core/utils/status.dart';
import 'package:challenge2/core/utils/translation.dart';
import 'package:challenge2/core/widgets/app_button.dart';
import 'package:challenge2/core/widgets/app_textfield.dart';
import 'package:challenge2/core/widgets/app_topbar.dart';
import 'package:challenge2/ui/bloc/main_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController(text: '');
  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');
  TextEditingController confirmPassController = TextEditingController(text: '');

  final _formRegister = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Widget content() {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Form(
              key: _formRegister,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AppTextField(
                    title: context.text.label_name,
                    hint: context.text.label_name,
                    keyboardType: TextInputType.name,
                    controller: nameController,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
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
                    height: 24,
                  ),
                  AppTextField(
                    title: context.text.label_confirm_password,
                    hint: context.text.label_confirm_password,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.text.label_error_empty;
                      } else if (value != passwordController.text) {
                        return context.text.label_error_password_not_match;
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.visiblePassword,
                    obscure: true,
                    controller: confirmPassController,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget footer() {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: AppButton(
          padding: 20,
          caption: context.text.label_save,
          isLoading: isLoading,
          onPressed: () => validateInput(),
        ),
      );
    }

    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) {
        if (state is RegisterResultState) {
          if (state.status == Status.loading) {
            isLoading = true;
          }
          if (state.status == Status.success) {
            isLoading = false;
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message.toString())));
            context.pop();
          }
          if (state.status == Status.error) {
            isLoading = false;
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message.toString())));
          }
        }
      },
      builder: (context, state) {
        return Container(
          color: Colors.white,
          child: SafeArea(
            child: Scaffold(
              appBar: AppTopBar(
                onPressed: () => context.pop(),
                title: context.text.label_register,
                height: 100,
              ),
              resizeToAvoidBottomInset: false,
              body: Column(
                children: [
                  content(),
                  footer(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void validateInput() {
    var email = emailController.text;
    var name = nameController.text;
    var password = passwordController.text;
    if (_formRegister.currentState!.validate()) {
      BlocProvider.of<MainBloc>(context)
          .add(Register(name: name, email: email, password: password));
    }
  }
}
