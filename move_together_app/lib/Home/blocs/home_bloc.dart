import 'package:flutter/foundation.dart';
import 'package:move_together_app/core/exceptions/api_exception.dart';
import 'package:move_together_app/core/models/trip.dart';
import 'package:move_together_app/core/services/api_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeDataLoaded>((event, emit) async {
      emit(HomeDataLoading());
      final apiServices = ApiServices();

      try {
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