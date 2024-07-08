part of 'note_bloc.dart';

@immutable
sealed class NoteState {}

final class NoteInitial extends NoteState {}

final class NotesDataLoading extends NoteState {}

final class NotesDataLoadingSuccess extends NoteState {
  final List<Note> notes;

  NotesDataLoadingSuccess({required this.notes});
}

final class NotesDataLoadingError extends NoteState {
  final String errorMessage;

  NotesDataLoadingError({required this.errorMessage});
}
