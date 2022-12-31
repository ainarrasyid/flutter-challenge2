import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:challenge2/core/utils/status.dart';
import 'package:challenge2/ui/bloc/main_bloc.dart';
import '../widget/im_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) {
        if (state is LoginResultState) {
          Future.delayed(const Duration(seconds: 3), () {
            if (state.status == Status.success && state.isLogin!) {
              context.go('/menu');
            } else if (state.status == Status.success && !state.isLogin!) {
              context.go('/login');
            } else if (state.status == Status.error) {
              context.go('/login');
            }
          });
        }
      },
      builder: (context, state) {
        return const Scaffold(
          body: ImFlutter(),
        );
      },
    );
  }
}
