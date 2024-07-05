part of 'photo_bloc.dart';

@immutable
sealed class PhotoState {}

final class PhotoInitial extends PhotoState {}

final class PhotosDataLoading extends PhotoState {}

final class PhotosDataLoadingSuccess extends PhotoState {
  final List<Photo> photos;

  PhotosDataLoadingSuccess({required this.photos});
}

final class PhotosDataLoadingError extends PhotoState {
  final String errorMessage;

  PhotosDataLoadingError({required this.errorMessage});
}
