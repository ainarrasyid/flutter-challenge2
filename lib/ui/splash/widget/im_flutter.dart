import 'package:challenge2/core/widgets/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:challenge2/core/widgets/app_theme.dart';

class ImFlutter extends StatelessWidget {
  const ImFlutter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.note_alt, color: AppColors.primary, size: 100),
        Text("My Notes",
            style:
                AppTheme().textTheme.headline4?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600))
      ],
    ));
  }
}
