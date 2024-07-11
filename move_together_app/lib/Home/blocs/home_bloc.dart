import 'package:flutter/cupertino.dart';
import 'package:move_together_app/core/exceptions/api_exception.dart';
import 'package:move_together_app/core/models/trip.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/core/services/trip_service.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(BuildContext context) : super(HomeInitial()) {
    final tripServices = TripService(context.read<AuthProvider>());

    on<HomeDataFetch>((event, emit) async {
      emit(HomeDataLoading());
      try {
        final trips = await tripServices.getAll();
        emit(HomeDataLoadingSuccess(trips: trips));
      } on ApiException catch (error) {
        emit(HomeDataLoadingError(errorMessage: error.message));
      } catch (error) {
        emit(HomeDataLoadingError(errorMessage: 'Unhandled error'));
      }
    });

    on<HomeDataLeaveTrip>((event, emit) async {
      emit(HomeDataLoading());
      try {
        await tripServices.leave(event.trip.id.toString());
        final trips = await tripServices.getAll();
        emit(HomeDataLoadingSuccess(trips: trips));
      } on ApiException catch (error) {
        emit(HomeDataLoadingError(errorMessage: error.message));
      } catch (error) {
        emit(HomeDataLoadingError(errorMessage: 'Unhandled error'));
      }
    });

    on<HomeDataDeleteTrip>((event, emit) async {
      emit(HomeDataLoading());
      try {
        await tripServices.delete(event.trip.id.toString());
        final trips = await tripServices.getAll();
        emit(HomeDataLoadingSuccess(trips: trips));
      } on ApiException catch (error) {
        emit(HomeDataLoadingError(errorMessage: error.message));
      } catch (error) {
        emit(HomeDataLoadingError(errorMessage: 'Unhandled error'));
      }
    });

    on<HomeDataFetchSingleTrip>((event, emit) async {
      try {
        final trip = await tripServices.get(event.tripId.toString());
        final trips = (state as HomeDataLoadingSuccess).trips;
        final index = trips.indexWhere((element) => element.id == trip.id);
        trips[index] = trip;
        emit(HomeDataLoadingSuccess(trips: trips));
      } on ApiException catch (error) {
        emit(HomeDataLoadingError(errorMessage: error.message));
      } catch (error) {
        emit(HomeDataLoadingError(errorMessage: 'Unhandled error'));
      }
    });
  }
}