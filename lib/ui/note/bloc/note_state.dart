part of 'note_bloc.dart';

abstract class NoteState extends Equatable {
  const NoteState();

  @override
  List<Object?> get props => [];
}

class NoteInitial extends NoteState {}

class NoteResultState extends NoteState {
  final Status status;
  final String? message;
  final List<Note>? data;

  const NoteResultState({required this.status, this.message, this.data});

  @override
  List<Object?> get props => [status, message, data];
}
