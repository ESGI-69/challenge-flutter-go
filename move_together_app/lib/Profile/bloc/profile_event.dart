part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

final class ProfileDataLoaded extends ProfileEvent {}

final class ProfilePictureUpdated extends ProfileEvent {}
