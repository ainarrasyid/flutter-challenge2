import 'package:flutter/material.dart';
import 'package:challenge2/core/utils/theme_extension.dart';

import 'app_colors.dart';

class AppSearchBar extends StatefulWidget {
  const AppSearchBar({
    Key? key,
    required this.hint,
    this.onClick,
    this.withElevation,
    this.readOnly = false,
    this.onChanged,
    this.paddingSize = const EdgeInsets.all(8.0),
    this.radius = 8.0,
  }) : super(key: key);
  final String hint;
  final Function? onClick;
  final bool? withElevation;
  final bool readOnly;
  final EdgeInsets paddingSize;
  final Function(String)? onChanged;
  final double radius;

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  final controller = TextEditingController();
  bool? showClearButton;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onClick?.call(),
      child: Material(
        color: Colors.transparent,
        elevation: widget.withElevation == true ? 1 : 0,
        child: TextField(
          enabled: widget.onClick == null,
          style: context.textTheme.bodyText2?.copyWith(color: Colors.black54),
          readOnly: widget.readOnly,
          onChanged: (data) {
            widget.onChanged?.call(data);
            setState(() {
              showClearButton = controller.text.isNotEmpty;
            });
          },
          controller: controller,
          decoration: InputDecoration(
            fillColor: AppColors.softGray,
            filled: true,
            hintText: widget.hint,
            hintStyle: context.textTheme.bodyText2?.copyWith(
              color: AppColors.textGray,
            ),
            contentPadding: widget.paddingSize,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radius),
              borderSide: BorderSide.none,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radius),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radius),
              borderSide: BorderSide.none,
            ),
            suffixIcon: showClearButton == true
                ? GestureDetector(
                    onTap: () {
                      controller.text = '';
                      widget.onChanged?.call('');
                      setState(() {
                        showClearButton = false;
                      });
                    },
                    child: const Icon(
                      Icons.cancel,
                      color: AppColors.primary,
                    ))
                : const Icon(
                    Icons.search,
                    color: AppColors.primary,
                  ),
          ),
        ),
      ),
    );
  }
}
