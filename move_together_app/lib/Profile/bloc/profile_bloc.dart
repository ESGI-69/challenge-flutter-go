import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:move_together_app/core/models/user.dart';
import 'package:move_together_app/core/services/api_services.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileEvent>((event, emit) async {
      emit(ProfileDataLoading());
      final apiServices = ApiServices();

      try {
        final profile = await apiServices.getProfile();
        emit(ProfileDataLoadingSuccess(profile: profile));
      } on Exception catch (error) {
        emit(ProfileDataLoadingError(errorMessage: error.toString()));
      } catch (error) {
        emit(ProfileDataLoadingError(errorMessage: 'Unhandled error'));
      }
    });
  }
}
