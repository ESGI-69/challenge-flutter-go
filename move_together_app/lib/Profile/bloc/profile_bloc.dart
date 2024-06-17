import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/core/models/user.dart';
import 'package:move_together_app/core/services/api_services.dart';

import '../../main.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(BuildContext context) : super(ProfileInitial()) {
    on<ProfileEvent>((event, emit) async {
      emit(ProfileDataLoading());
      final apiServices = ApiServices(context.read<AuthProvider>());

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
