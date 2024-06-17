import 'package:flutter/foundation.dart';
import 'package:move_together_app/core/exceptions/api_exception.dart';
import 'package:move_together_app/core/models/trip.dart';
import 'package:move_together_app/core/services/api_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'trip_event.dart';
part 'trip_state.dart';

class TripBloc extends Bloc<TripEvent, TripState> {
  TripBloc() : super(TripInitial()) {

    on<TripDataCreateTrip>((event, emit) async {
      emit(TripDataLoading());
      final apiServices = ApiServices();
      try {
        await apiServices.createTrip(event.trip);
        final trip = event.trip;
        emit(TripDataLoadingSuccess(trip: trip));
      } on ApiException catch (error) {
        emit(TripDataLoadingError(errorMessage: error.message));
      } catch (error) {
        emit(TripDataLoadingError(errorMessage: 'Unhandled error'));
      }
    });
  }
}