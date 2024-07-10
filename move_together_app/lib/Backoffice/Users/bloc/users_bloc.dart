import 'package:flutter/cupertino.dart';
import 'package:move_together_app/core/exceptions/api_exception.dart';
import 'package:move_together_app/core/models/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/core/services/admin_service.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  UsersBloc(BuildContext context) : super(UsersInitial()) {
    final adminServices = AdminService(context.read<AuthProvider>());

    on<UsersDataFetch>((event, emit) async {
      emit(UsersDataLoading());
      try {
        final users = await adminServices.getAllUsers();
        emit(UsersDataLoadingSuccess(users: users));
      } on ApiException catch (error) {
        emit(UsersDataLoadingError(errorMessage: error.message));
      } catch (error) {
        emit(UsersDataLoadingError(errorMessage: 'Unhandled error'));
      }
    });

    on<UserDataUpdateUser>((event, emit) async {
      emit(UsersDataLoading());
      try {
        await adminServices.changeRoleUser(event.user);
        final users = await adminServices.getAllUsers();
        emit(UsersDataLoadingSuccess(users: users));
      } on ApiException catch (error) {
        emit(UsersDataLoadingError(errorMessage: error.message));
      } catch (error) {
        emit(UsersDataLoadingError(errorMessage: 'Unhandled error'));
      }
    });
  }
}