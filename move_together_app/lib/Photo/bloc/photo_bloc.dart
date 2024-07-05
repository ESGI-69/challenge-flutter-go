import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/core/models/photo.dart';
import 'package:move_together_app/core/services/photo_service.dart';

part 'photo_event.dart';
part 'photo_state.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  PhotoBloc(BuildContext context) : super(PhotoInitial()) {
    final photoService = PhotoService(context.read<AuthProvider>());

    on<PhotosDataFetch>((event, emit) async {
      emit(PhotosDataLoading());

      try {
        final photos = await photoService.getAll(event.tripId);
        emit(PhotosDataLoadingSuccess(photos: photos));
      } catch (error) {
        emit(PhotosDataLoadingError(errorMessage: 'Failed to get photos'));
      }
    });
  }
}
