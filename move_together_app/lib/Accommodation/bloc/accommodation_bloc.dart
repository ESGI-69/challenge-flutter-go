import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/core/exceptions/api_exception.dart';
import 'package:move_together_app/core/models/accommodation.dart';
import 'package:move_together_app/core/services/accommodation_service.dart';

part 'accommodation_event.dart';
part 'accommodation_state.dart';

class AccommodationBloc extends Bloc<AccommodationEvent, AccommodationState> {
  AccommodationBloc(BuildContext context) : super(AccommodationInitial()) {
    final apiServices = AccommodationService(context.read<AuthProvider>());
    on<AccommodationsDataFetch>((event, emit) async {
      emit(AccommodationDataLoading());

      try {
        final accommodations = await apiServices.getAll(event.tripId);
        emit(AccommodationsDataLoadingSuccess(accommodations: accommodations));
      } on ApiException catch (error) {
        emit(AccommodationsDataLoadingError(errorMessage: error.message));
      } catch (error) {
        emit(AccommodationsDataLoadingError(errorMessage: 'Unhandled error'));
      }
    });
  }
}
