import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/core/models/user.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/core/services/user_service.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(BuildContext context) : super(ProfileInitial()) {
    final authProvider = context.read<AuthProvider>();
    final userService = UserService(authProvider);
    on<ProfileEvent>((event, emit) async {
      emit(ProfileDataLoading());

      try {
        final profile = await userService.get(authProvider.userId.toString());
        emit(ProfileDataLoadingSuccess(profile: profile));
      } on Exception catch (error) {
        emit(ProfileDataLoadingError(errorMessage: error.toString()));
      } catch (error) {
        emit(ProfileDataLoadingError(errorMessage: 'Unhandled error'));
      }
    });
  }
}
