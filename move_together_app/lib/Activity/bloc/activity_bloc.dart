import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/core/exceptions/api_exception.dart';
import 'package:move_together_app/core/models/activity.dart';
import 'package:move_together_app/core/services/activity_service.dart';

part 'activity_event.dart';
part 'activity_state.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  ActivityBloc(BuildContext context) : super(ActivityInitial()) {
    final apiServices = ActivityService(context.read<AuthProvider>());
    on<ActivitiesDataFetch>((event, emit) async {
      emit(ActivitiesDataLoading());

      try {
        final activities = await apiServices.getAll(event.tripId);
        emit(ActivitiesDataLoadingSuccess(activities: activities));
      } on ApiException catch (error) {
        emit(ActivitiesDataLoadingError(errorMessage: error.message));
      } catch (error) {
        emit(ActivitiesDataLoadingError(errorMessage: 'Unhandled error'));
      }
    });
  }
}
