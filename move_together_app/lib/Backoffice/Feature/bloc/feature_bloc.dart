import 'package:flutter/cupertino.dart';
import 'package:move_together_app/core/exceptions/api_exception.dart';
import 'package:move_together_app/core/models/feature.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/core/services/admin_service.dart';

part 'feature_event.dart';
part 'feature_state.dart';

class FeatureBloc extends Bloc<FeaturesEvent, FeaturesState> {
  FeatureBloc(BuildContext context) : super(FeaturesInitial()) {
    final adminServices = AdminService(context.read<AuthProvider>());

    on<FeaturesDataFetch>((event, emit) async {
      emit(FeaturesDataLoading());
      try {
        final features = await adminServices.getAllFeatures();
        emit(FeaturesDataLoadingSuccess(features: features));
      } on ApiException catch (error) {
        emit(FeaturesDataLoadingError(errorMessage: error.message));
      } catch (error) {
        emit(FeaturesDataLoadingError(errorMessage: 'Unhandled error'));
      }
    });

    on<FeatureDataPatchFeature>((event, emit) async {
      try {
        final feature = await adminServices.patchFeature(
            event.feature.name.toString().split('.').last,
            event.feature.isEnabled);
        if (state is FeaturesDataLoadingSuccess) {
          final features = (state as FeaturesDataLoadingSuccess).features;
          final index =
              features.indexWhere((element) => element.name == feature.name);
          if (index != -1) {
            features[index] = feature;
            emit(FeaturesDataLoadingSuccess(features: features));
          }
        }
      } on ApiException catch (error) {
        emit(FeaturesDataLoadingError(errorMessage: error.message));
      } catch (error) {
        emit(FeaturesDataLoadingError(errorMessage: 'Unhandled error'));
      }
    });
  }
}
