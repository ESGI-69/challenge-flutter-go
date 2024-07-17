import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/core/exceptions/api_exception.dart';
import 'package:move_together_app/core/models/note.dart';
import 'package:move_together_app/core/services/note_service.dart';
import 'package:move_together_app/utils/exception_to_string.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  NoteBloc(BuildContext context) : super(NoteInitial()) {
    final apiServices = NoteService(context.read<AuthProvider>());
    on<NotesDataFetch>((event, emit) async {
      emit(NotesDataLoading());

      try {
        final notes = await apiServices.getAll(event.tripId);
        emit(NotesDataLoadingSuccess(notes: notes));
      } on ApiException catch (error) {
        emit(NotesDataLoadingError(errorMessage: error.message));
      } catch (error) {
        emit(NotesDataLoadingError(errorMessage: exceptionToString(error)));
      }
    });
  }
}
