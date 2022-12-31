import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:challenge2/core/data/datasource/api/notes_api.dart';
import 'package:challenge2/core/data/model/note.dart';
import 'package:challenge2/core/utils/dio_error_wrapper.dart';

import '../../../core/utils/status.dart';

part 'note_event.dart';
part 'note_state.dart';

@Injectable()
class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NoteApi api;
  List<Note>? listNote;

  NoteBloc(this.api) : super(NoteInitial()) {
    on<GetNote>((event, emit) async {
      emit(const NoteResultState(status: Status.loading));
      try {
        final response = await api.getNote();
        listNote = response.data;
        emit(NoteResultState(
            status: Status.success,
            data: listNote
              ?..sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!)),
            message: response.message));
      } catch (e) {
        if (e is DioErrorWrapper) {
          emit(NoteResultState(
              status: Status.error, message: e.dioError.message));
        } else {
          emit(NoteResultState(status: Status.error, message: e.toString()));
        }
      }
    });

    on<CreateNote>((event, emit) async {
      emit(const NoteResultState(status: Status.loading));
      try {
        await api.createNote(event.title, event.content);
        add(const GetNote());
      } catch (e) {
        if (e is DioErrorWrapper) {
          emit(NoteResultState(
              status: Status.error, message: e.dioError.message));
        } else {
          emit(NoteResultState(status: Status.error, message: e.toString()));
        }
        add(const GetNote());
      }
    });

    on<UpdateNote>((event, emit) async {
      emit(const NoteResultState(status: Status.loading));
      try {
        await api.updateNote(event.id, event.title, event.content);
        add(const GetNote());
      } catch (e) {
        if (e is DioErrorWrapper) {
          emit(NoteResultState(
              status: Status.error, message: e.dioError.message));
        } else {
          emit(NoteResultState(status: Status.error, message: e.toString()));
        }
        add(const GetNote());
      }
    });

    on<DeleteNote>((event, emit) async {
      try {
        await api.deleteNote(event.id);
        add(const GetNote());
      } catch (e) {
        if (e is DioErrorWrapper) {
          emit(NoteResultState(
              status: Status.error, message: e.dioError.message));
        } else {
          emit(NoteResultState(status: Status.error, message: e.toString()));
        }
        add(const GetNote());
      }
    });

    on<FilterNote>((event, emit) {
      List<Note> result = [];
      if (event.query.isEmpty && listNote == null) {
        result = listNote!;
      } else {
        result = listNote!
            .where((note) =>
                note.title!.toLowerCase().contains(event.query.toLowerCase()) ||
                note.content!.toLowerCase().contains(event.query.toLowerCase()))
            .toList();
      }
      emit(NoteResultState(status: Status.success, data: result));
    });
  }
}
