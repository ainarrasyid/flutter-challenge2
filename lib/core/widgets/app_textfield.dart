import 'package:flutter/material.dart';
import 'package:challenge2/core/utils/theme_extension.dart';
import 'app_colors.dart';

class AppTextField extends StatefulWidget {
  final String title;
  final String hint;
  final bool obscure;
  final Color textHintColor;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final String? errorText;
  final Widget? endIcon;
  final Function? endIconClicked;
  final String? Function(String?)? validator;
  final bool? readOnlyField;
  final TextInputType? keyboardType;
  const AppTextField({
    Key? key,
    required this.title,
    required this.hint,
    this.obscure = false,
    this.textHintColor = AppColors.textGray,
    this.controller,
    this.onChanged,
    this.errorText,
    this.endIcon,
    this.endIconClicked,
    this.readOnlyField,
    this.keyboardType,
    this.validator,
  }) : super(key: key);

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool isVisible = false;
  bool focused = false;
  bool alreadyClicked = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: context.textTheme.bodyText2?.copyWith(
              color: widget.errorText != null && alreadyClicked
                  ? Colors.red
                  : focused
                      ? AppColors.primary
                      : widget.textHintColor,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          FocusScope(
            onFocusChange: (focus) {
              setState(() {
                focused = focus;
                alreadyClicked = true;
              });
            },
            child: TextFormField(
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  ?.copyWith(color: Colors.black),
              obscureText: widget.obscure && isVisible == false,
              controller: widget.controller,
              onChanged: widget.onChanged,
              readOnly: widget.readOnlyField == true,
              keyboardType: widget.keyboardType,
              validator: widget.validator ??
                  (value) {
                    if (value == null || value.isEmpty) {
                      return " ${widget.title} Can't Empty";
                    }
                    return null;
                  },
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.softGray,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.softGray,
                  ),
                ),
                hintText: widget.hint,
                filled: true,
                fillColor: Colors.white,
                errorText: alreadyClicked ? widget.errorText : null,
                suffixIcon: widget.obscure
                    ? InkWell(
                        onTap: () => setState(() => isVisible = !isVisible),
                        child: Icon(isVisible
                            ? Icons.visibility_off
                            : Icons.visibility),
                      )
                    : widget.endIcon != null
                        ? InkWell(
                            child: widget.endIcon,
                            onTap: () => widget.endIconClicked?.call(),
                          )
                        : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
