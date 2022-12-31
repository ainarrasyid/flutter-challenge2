import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:challenge2/core/data/model/user.dart';
import 'package:challenge2/core/utils/status.dart';
import 'package:challenge2/core/utils/translation.dart';
import 'package:challenge2/ui/bloc/main_bloc.dart';
import 'package:challenge2/ui/home/home_screen.dart';
import 'package:challenge2/ui/note/bloc/note_bloc.dart';
import 'package:challenge2/ui/profile/profile_screen.dart';

import '../core/widgets/app_colors.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  var currentScreen = 0;
  User user = const User();

  @override
  void initState() {
    BlocProvider.of<NoteBloc>(context).add(const GetNote());
    super.initState();
  }

  final screens = [
    const HomeScreen(),
    const ProfileScreen(),
  ];

  clearFocus() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.focusedChild?.unfocus();
    }
  }

  List<BottomNavigationBarItem> get bottomNavBarItem {
    return <BottomNavigationBarItem>[
      BottomNavigationBarItem(
          icon: const Icon(Icons.home), label: context.text.home),
      BottomNavigationBarItem(
          icon: CircleAvatar(
            radius: 15,
            backgroundImage: NetworkImage(
                user.photo != null ? user.photo! : 'https://picsum.photos/200'),
          ),
          label: context.text.profile),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        if (state is LoginResultState) {
          if (state.status == Status.success) {
            user = state.data!;
          }
          if (state.status == Status.error) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.text.label_error_get_user)));
          }
        }
        return GestureDetector(
          onTap: () {
            clearFocus();
          },
          child: Scaffold(
            body: IndexedStack(
              index: currentScreen,
              children: screens,
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: AppColors.primary,
              onPressed: () {
                context.push('/note', extra: null);
                clearFocus();
              },
              child: const Icon(Icons.add),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.white,
              selectedItemColor: AppColors.primary,
              elevation: 0,
              items: bottomNavBarItem,
              currentIndex: currentScreen,
              onTap: (index) {
                setState(() => currentScreen = index);
                clearFocus();
              },
            ),
          ),
        );
      },
    );
  }
}
