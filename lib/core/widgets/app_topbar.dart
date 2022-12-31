import 'package:flutter/material.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final Function onPressed;
  final String title;
  final double height;

  const AppTopBar(
      {super.key,
      required this.onPressed,
      required this.title,
      this.height = kToolbarHeight});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 100,
      centerTitle: true,
      title: Text(title),
      leading: GestureDetector(
        child: const Icon(Icons.arrow_back),
        onTap: () => onPressed(),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
