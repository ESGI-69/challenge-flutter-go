part of 'users_admin_bloc.dart';

@immutable
sealed class UsersEvent {}

final class UsersDataFetch extends UsersEvent {}

final class UserDataUpdateUser extends UsersEvent {
  final User user;

  UserDataUpdateUser(this.user);
}
