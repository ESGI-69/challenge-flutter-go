part of 'photo_bloc.dart';

@immutable
sealed class PhotoEvent {}

final class PhotosDataFetch extends PhotoEvent {
  final int tripId;

  PhotosDataFetch(this.tripId);
}
