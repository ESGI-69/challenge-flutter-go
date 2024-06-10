part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileDataLoading extends ProfileState {}

final class ProfileDataLoadingSuccess extends ProfileState {
  final User profile;

  ProfileDataLoadingSuccess({required this.profile});
}

final class ProfileDataLoadingError extends ProfileState {
  final String errorMessage;

  ProfileDataLoadingError({required this.errorMessage});
}
