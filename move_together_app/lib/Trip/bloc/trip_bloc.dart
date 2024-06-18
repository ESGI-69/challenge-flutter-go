import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/core/exceptions/api_exception.dart';
import 'package:move_together_app/core/models/trip.dart';
import 'package:move_together_app/core/services/api_services.dart';
import 'package:move_together_app/Provider/auth_provider.dart';

part 'trip_event.dart';
part 'trip_state.dart';

class TripBloc extends Bloc<TripEvent, TripState> {
  TripBloc(BuildContext context) : super(TripInitial()) {
    on<TripDataFetch>((event, emit) async {
      emit(TripDataLoading());
      final apiServices = ApiServices(context.read<AuthProvider>());

      try {
        final trip = await apiServices.getTrip(event.tripId);
        emit(TripDataLoadingSuccess(trip: trip));
      } on ApiException catch (error) {
        emit(TripDataLoadingError(errorMessage: error.message));
      } catch (error) {
        emit(TripDataLoadingError(errorMessage: 'Unhandled error'));
      }
    });

    on<TripEdit>((event, emit) async {
      emit(TripDataLoading());
      final apiServices = ApiServices(context.read<AuthProvider>());

      try {
        final trip = await apiServices.editTrip(
          event.tripId,
          name: event.name,
          country: event.country,
          city: event.city,
          startDate: event.startDate?.toIso8601String(),
          endDate: event.endDate?.toIso8601String(),
        );
        emit(TripDataLoadingSuccess(trip: trip));
      } on ApiException catch (error) {
        emit(TripDataLoadingError(errorMessage: error.message));
      } catch (error) {
        emit(TripDataLoadingError(errorMessage: 'Unhandled error'));
      }
    });
  }
}
