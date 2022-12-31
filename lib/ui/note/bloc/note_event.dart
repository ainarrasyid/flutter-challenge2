part of 'note_bloc.dart';

abstract class NoteEvent extends Equatable {
  const NoteEvent();

  @override
  List<Object> get props => [];
}

class GetNote extends NoteEvent {
  const GetNote();

  @override
  List<Object> get props => [];
}

class CreateNote extends NoteEvent {
  final String title;
  final String content;

  const CreateNote({required this.title, required this.content});

  @override
  List<Object> get props => [title, content];
}

class UpdateNote extends NoteEvent {
  final String id;
  final String title;
  final String content;

  const UpdateNote(
      {required this.id, required this.title, required this.content});

  @override
  List<Object> get props => [id, title, content];
}

class DeleteNote extends NoteEvent {
  final String id;

  const DeleteNote({required this.id});

  @override
  List<Object> get props => [id];
}

class FilterNote extends NoteEvent {
  final String query;

  const FilterNote({required this.query});

  @override
  List<Object> get props => [query];
}
