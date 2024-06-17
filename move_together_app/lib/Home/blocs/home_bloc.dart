import 'package:flutter/src/widgets/framework.dart';
import 'package:move_together_app/core/exceptions/api_exception.dart';
import 'package:move_together_app/core/models/trip.dart';
import 'package:move_together_app/core/services/api_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/Provider/auth_provider.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(BuildContext context) : super(HomeInitial()) {
    on<HomeDataFetch>((event, emit) async {
      emit(HomeDataLoading());
      final apiServices = ApiServices(context.read<AuthProvider>());

      try {
        final trips = await apiServices.getTrips();
        emit(HomeDataLoadingSuccess(trips: trips));
      } on ApiException catch (error) {
        emit(HomeDataLoadingError(errorMessage: error.message));
      } catch (error) {
        emit(HomeDataLoadingError(errorMessage: 'Unhandled error'));
      }
    });

    on<HomeDataLeaveTrip>((event, emit) async {
      emit(HomeDataLoading());
      final apiServices = ApiServices(context.read<AuthProvider>());
      try {
        await apiServices.leaveTrip(event.trip.id.toString());
        final trips = await apiServices.getTrips();
        emit(HomeDataLoadingSuccess(trips: trips));
      } on ApiException catch (error) {
        emit(HomeDataLoadingError(errorMessage: error.message));
      } catch (error) {
        emit(HomeDataLoadingError(errorMessage: 'Unhandled error'));
      }
    });

    on<HomeDataDeleteTrip>((event, emit) async {
      emit(HomeDataLoading());
      final apiServices = ApiServices(context.read<AuthProvider>());
      try {
        await apiServices.deleteTrip(event.trip.id.toString());
        final trips = await apiServices.getTrips();
        emit(HomeDataLoadingSuccess(trips: trips));
      } on ApiException catch (error) {
        emit(HomeDataLoadingError(errorMessage: error.message));
      } catch (error) {
        emit(HomeDataLoadingError(errorMessage: 'Unhandled error'));
      }
    });
  }
}