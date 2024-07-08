import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/core/exceptions/api_exception.dart';
import 'package:move_together_app/core/models/trip.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/core/services/trip_service.dart';

part 'trip_event.dart';
part 'trip_state.dart';

class TripBloc extends Bloc<TripEvent, TripState> {
  TripBloc(BuildContext context) : super(TripInitial()) {
    final tripServices = TripService(context.read<AuthProvider>());

    on<TripDataFetch>((event, emit) async {
      emit(TripDataLoading());
      try {
        final trip = await tripServices.get(event.tripId.toString());
        emit(TripDataLoadingSuccess(trip: trip));
      } on ApiException catch (error) {
        emit(TripDataLoadingError(errorMessage: error.message));
      } catch (error) {
        emit(TripDataLoadingError(errorMessage: 'Unhandled error'));
      }
    });

    on<TripDataCreateTrip>((event, emit) async {
      emit(TripDataLoading());
      try {
        final trip =  await tripServices.create(event.trip);
        emit(TripDataLoadingSuccess(trip: trip));
      } on ApiException catch (error) {
        emit(TripDataLoadingError(errorMessage: error.message));
      } catch (error) {
        emit(TripDataLoadingError(errorMessage: 'Unhandled error'));
      }
    });
  }
}
