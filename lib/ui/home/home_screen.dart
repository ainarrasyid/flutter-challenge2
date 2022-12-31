import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:challenge2/core/data/model/note.dart';
import 'package:challenge2/core/utils/status.dart';
import 'package:challenge2/core/utils/translation.dart';
import 'package:challenge2/core/widgets/app_colors.dart';
import 'package:challenge2/core/widgets/app_search_bar.dart';
import 'package:challenge2/core/widgets/app_theme.dart';

import '../note/bloc/note_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    Widget header() {
      return Padding(
        padding:
            const EdgeInsets.only(left: 24, right: 24, top: 47, bottom: 32),
        child: AppSearchBar(
          hint: context.text.label_find_notes,
          paddingSize: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          radius: 15.0,
          onChanged: (query) {
            BlocProvider.of<NoteBloc>(context).add(FilterNote(query: query));
          },
        ),
      );
    }

    Widget content(int index, Note note) {
      return Dismissible(
        key: ValueKey<int>(index),
        onDismissed: (direction) {
          BlocProvider.of<NoteBloc>(context).add(DeleteNote(id: note.id!));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(width: 1, color: AppColors.secondaryGray),
          ),
          padding: const EdgeInsets.all(15.0),
          margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: InkWell(
            onTap: () => context.push('/note', extra: note),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.title!,
                  maxLines: 3,
                  style: AppTheme().contentTitle,
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  note.content!,
                  maxLines: 5,
                  style: AppTheme().contentBody,
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget body() {
      return BlocBuilder<NoteBloc, NoteState>(
        buildWhen: (previous, current) => current is NoteResultState,
        builder: (context, state) {
          if (state is NoteResultState) {
            if (state.status == Status.success) {
              if (state.data!.isNotEmpty) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: state.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return content(index, state.data![index]);
                    },
                  ),
                );
              } else {
                return Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.description,
                          size: 80.0,
                          color: AppColors.textGray,
                        ),
                        Text(
                          context.text.label_empty_notes,
                          style: AppTheme()
                              .textTheme
                              .headline6
                              ?.copyWith(color: AppColors.textGray),
                        )
                      ],
                    ),
                  ),
                );
              }
            }
          }
          return const Expanded(
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            ),
          );
        },
      );
    }

    return SafeArea(
      child: BlocConsumer<NoteBloc, NoteState>(
        listener: (context, state) {
          // log(state.toString());
        },
        builder: (context, state) {
          return Scaffold(
            body: Column(
              children: [
                header(),
                body(),
              ],
            ),
          );
        },
      ),
    );
  }
}
