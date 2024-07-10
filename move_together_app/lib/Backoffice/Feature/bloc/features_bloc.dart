import 'package:flutter/cupertino.dart';
import 'package:move_together_app/core/exceptions/api_exception.dart';
import 'package:move_together_app/core/models/feature.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/core/services/admin_service.dart';
import 'package:move_together_app/core/services/feature_service.dart';

part 'features_event.dart';
part 'features_state.dart';

class FeatureBloc extends Bloc<FeaturesEvent, FeaturesState> {
  FeatureBloc(BuildContext context) : super(FeaturesInitial()) {
    final adminServices = AdminService(context.read<AuthProvider>());
    final featureServices = FeatureService(context.read<AuthProvider>());

    on<FeaturesDataFetch>((event, emit) async {
      emit(FeaturesDataLoading());
      try {
        final features = await featureServices.getAll();
        emit(FeaturesDataLoadingSuccess(features: features));
      } on ApiException catch (error) {
        emit(FeaturesDataLoadingError(errorMessage: error.message));
      } catch (error) {
        emit(FeaturesDataLoadingError(errorMessage: 'Unhandled error'));
      }
    });

    on<FeatureDataPatchFeature>((event, emit) async {
      emit(FeaturesDataLoading());
      try {
        await adminServices.patchFeature(event.feature.name.toString());
        final features = await featureServices.getAll();
        emit(FeaturesDataLoadingSuccess(features: features));
      } on ApiException catch (error) {
        emit(FeaturesDataLoadingError(errorMessage: error.message));
      } catch (error) {
        emit(FeaturesDataLoadingError(errorMessage: 'Unhandled error'));
      }
    });
  }
}
