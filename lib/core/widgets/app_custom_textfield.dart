import 'package:challenge2/core/widgets/app_theme.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextFieldNote extends StatefulWidget {
  final String hint;
  final Color textHintColor;
  final double textSize;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final String? errorText;
  final bool? readOnlyField;
  final bool isTitle;
  final TextInputType? keyboardType;
  const AppTextFieldNote({
    Key? key,
    required this.hint,
    this.textHintColor = AppColors.textGray,
    this.controller,
    this.onChanged,
    this.errorText,
    this.isTitle = true,
    this.readOnlyField,
    this.keyboardType,
    this.textSize = 12.0,
  }) : super(key: key);

  @override
  State<AppTextFieldNote> createState() => _AppTextFieldNoteState();
}

class _AppTextFieldNoteState extends State<AppTextFieldNote> {
  late FocusNode focusNode;

  @override
  void initState() {
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  bool isVisible = false;
  bool focused = false;
  bool alreadyClicked = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => focusNode.requestFocus(),
      child: SizedBox(
        width: double.infinity,
        child: FocusScope(
          onFocusChange: (focus) {
            setState(() {
              focused = focus;
              alreadyClicked = true;
            });
          },
          child: SingleChildScrollView(
            child: TextField(
              focusNode: focusNode,
              maxLines: widget.isTitle ? 2 : null,
              minLines: widget.isTitle ? 1 : null,
              style: AppTheme()
                  .contentTitle
                  .copyWith(color: Colors.black, fontSize: widget.textSize),
              controller: widget.controller,
              onChanged: widget.onChanged,
              readOnly: widget.readOnlyField == true,
              keyboardType: widget.keyboardType,
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: widget.hint,
                hintStyle: TextStyle(color: widget.textHintColor),
                filled: true,
                fillColor: Colors.white,
                errorText: alreadyClicked ? widget.errorText : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
