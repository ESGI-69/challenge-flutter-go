import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/core/exceptions/api_exception.dart';
import 'package:move_together_app/core/models/participant.dart';
import 'package:move_together_app/core/services/participant_service.dart';

part 'participant_event.dart';
part 'participant_state.dart';

class ParticipantBloc extends Bloc<ParticipantEvent, ParticipantState> {
  ParticipantBloc(BuildContext context) : super(ParticipantInitial()) {
    final participantService = ParticipantService(context.read<AuthProvider>());

    on<ParticipantDataFetch>((event, emit) async {
      emit(ParticipantDataLoading());
      try {
        final participants = await participantService.getAll(event.tripId);
        emit(ParticipantDataLoadingSuccess(participants: participants));
      } on ApiException catch (error) {
        emit(ParticipantDataLoadingError(errorMessage: error.message));
      } catch (error) {
        emit(ParticipantDataLoadingError(errorMessage: error.toString()));
      }
    });
  }
}
