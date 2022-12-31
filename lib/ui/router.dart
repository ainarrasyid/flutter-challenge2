import 'package:flutter/material.dart';
import 'package:challenge2/core/data/model/note.dart';
import 'package:challenge2/ui/login/login_screen.dart';
import 'package:challenge2/ui/note/note_screen.dart';
import 'package:challenge2/ui/profile/profile_edit_screen.dart';
import 'package:challenge2/ui/register/register_screen.dart';
import '../ui/menu_screen.dart';
import 'package:go_router/go_router.dart';
import 'splash/screen/splash_screen.dart';

var router = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => const SplashScreen(),
  ),
  GoRoute(
    path: '/menu',
    builder: (context, state) => const MenuScreen(),
  ),
  GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
  GoRoute(
    path: '/register',
    builder: (context, state) => const RegisterScreen(),
  ),
  GoRoute(
    path: '/profile/edit',
    builder: (context, state) => const ProfileEditScreen(),
  ),
  GoRoute(
    path: '/note',
    name: 'note',
    builder: (context, state) {
      Note? note = state.extra != null ? state.extra as Note : null;
      return NoteScreen(
        note: note,
      );
    },
  )
]);

Widget get errorPage => const Center(
      child: SizedBox(
        width: 200,
        child: Text('Error, maybe you forgot to include required obj'),
      ),
    );
