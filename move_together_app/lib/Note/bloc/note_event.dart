part of 'note_bloc.dart';

@immutable
sealed class NoteEvent {}

final class NotesDataFetch extends NoteEvent {
  final int tripId;

  NotesDataFetch(this.tripId);
}
