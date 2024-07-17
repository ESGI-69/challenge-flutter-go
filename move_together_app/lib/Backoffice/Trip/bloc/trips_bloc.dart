import 'package:flutter/cupertino.dart';
import 'package:move_together_app/core/exceptions/api_exception.dart';
import 'package:move_together_app/core/models/trip.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/core/services/admin_service.dart';

part 'trips_event.dart';
part 'trips_state.dart';

class TripBloc extends Bloc<TripsEvent, TripsState> {
  TripBloc(BuildContext context) : super(TripsInitial()) {
    final adminServices = AdminService(context.read<AuthProvider>());

    on<TripsDataFetch>((event, emit) async {
      emit(TripsDataLoading());
      try {
        final trips = await adminServices.getAllTrips();
        emit(TripsDataLoadingSuccess(trips: trips));
      } on ApiException catch (error) {
        emit(TripsDataLoadingError(errorMessage: error.message));
      } catch (error) {
        emit(TripsDataLoadingError(errorMessage: 'Unhandled error'));
      }
    });

    on<TripDataDeleteTrip>((event, emit) async {
      try {
        await adminServices.deleteTrip(event.trip.id.toString());
        if (state is TripsDataLoadingSuccess) {
          final trips = (state as TripsDataLoadingSuccess).trips;
          final index =
              trips.indexWhere((element) => element.id == event.trip.id);
          if (index != -1) {
            trips.removeAt(index);
            emit(TripsDataLoadingSuccess(trips: trips));
          }
        }
        final trips = await adminServices.getAllTrips();
        emit(TripsDataLoadingSuccess(trips: trips));
      } on ApiException catch (error) {
        emit(TripsDataLoadingError(errorMessage: error.message));
      } catch (error) {
        emit(TripsDataLoadingError(errorMessage: 'Unhandled error'));
      }
    });
  }
}
