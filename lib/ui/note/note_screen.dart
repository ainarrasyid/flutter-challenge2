import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:challenge2/core/data/model/note.dart';
import 'package:challenge2/core/utils/datetime_extension.dart';
import 'package:challenge2/core/utils/translation.dart';
import 'package:challenge2/core/widgets/app_colors.dart';
import 'package:challenge2/core/widgets/app_custom_textfield.dart';
import 'package:challenge2/core/widgets/app_theme.dart';
import 'package:challenge2/core/widgets/app_topbar.dart';
import 'package:challenge2/ui/note/bloc/note_bloc.dart';

class NoteScreen extends StatefulWidget {
  final Note? note;
  const NoteScreen({super.key, this.note});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  String? updatedAt;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      titleController.text = widget.note!.title!;
      contentController.text = widget.note!.content!;
      final updatedDate =
          DateTime.fromMillisecondsSinceEpoch(widget.note!.updatedAt!);
      updatedAt = updatedDate.dateFormat('HH.mm');
    }
  }

  validateInput() {
    Note? note = widget.note;
    String title = titleController.text;
    String content = contentController.text;
    if (title.isEmpty || content.isEmpty) {
      return true;
    }
    if (note == null) {
      BlocProvider.of<NoteBloc>(context)
          .add(CreateNote(title: title, content: content));
      return true;
    }
    if (title != note.title || content != note.content) {
      BlocProvider.of<NoteBloc>(context).add(
          UpdateNote(id: widget.note!.id!, title: title, content: content));
      return true;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Widget content() {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AppTextFieldNote(
                hint: context.text.hint_title,
                textSize: 20,
                textHintColor: AppColors.textBlack,
                controller: titleController,
              ),
              Expanded(
                child: AppTextFieldNote(
                  hint: context.text.hint_content,
                  textSize: 14,
                  isTitle: false,
                  controller: contentController,
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget footer() {
      if (widget.note != null) {
        return Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Text(
              context.text.label_edited_at(updatedAt!),
              style: AppTheme().contentTitle.copyWith(color: Colors.black),
            ),
          ),
        );
      } else {
        return const SizedBox.shrink();
      }
    }

    return WillPopScope(
      onWillPop: () async {
        return validateInput();
      },
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: Scaffold(
            appBar: AppTopBar(
              onPressed: () => validateInput() ? context.pop() : null,
              title: '',
            ),
            resizeToAvoidBottomInset: true,
            body: Column(
              children: [
                content(),
                footer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
