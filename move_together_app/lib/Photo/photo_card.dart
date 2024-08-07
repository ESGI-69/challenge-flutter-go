import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:move_together_app/Photo/bloc/photo_bloc.dart';
import 'package:move_together_app/Photo/photo_item.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/Widgets/Card/trip_feature_card.dart';
import 'package:move_together_app/core/services/photo_service.dart';
import 'package:move_together_app/utils/photo_picker.dart';
import 'package:move_together_app/utils/exception_to_string.dart';

class PhotoCard extends StatelessWidget {
  final int tripId;
  final bool userHasEditPermission;
  final bool userIsOwner;

  const PhotoCard({
    super.key,
    required this.tripId,
    required this.userHasEditPermission,
    required this.userIsOwner,
  });

  @override
  Widget build(BuildContext context) {
    final photoService = PhotoService(context.read<AuthProvider>());

    return BlocProvider(
      create: (context) => PhotoBloc(context)..add(PhotosDataFetch(tripId)),
      child: BlocBuilder<PhotoBloc, PhotoState>(
        builder: (context, state) {
          if (state is PhotosDataLoadingSuccess) {
            return TripFeatureCard(
              title: 'Photos',
              emptyMessage: 'Aucune photo pour le moment',
              showAddButton: userHasEditPermission,
              icon: Icons.camera_alt,
              isLoading: state is PhotosDataLoading,
              type: TripFeatureCardType.grid,
              length: state.photos.length,
              onAddTap: () async {
                final XFile? image = await pickPhoto(context);
                if (image != null) {
                  try {
                    await photoService.create(tripId, image);
                    context.read<PhotoBloc>().add(PhotosDataFetch(tripId));
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(exceptionToString(error)),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                    );
                  }
                }
              },
              onTitleTap: state.photos.isNotEmpty
                  ? () async {
                      await context.pushNamed(
                        'photos',
                        pathParameters: {'tripId': tripId.toString()},
                        queryParameters: {
                          'hasEditPermission': userHasEditPermission.toString()
                        },
                      );
                      context.read<PhotoBloc>().add(PhotosDataFetch(tripId));
                    }
                  : null,
              itemBuilder: (context, index) => PhotoItem(
                tripId: tripId,
                photo: state.photos[index],
                onDeleteSuccess: (photo) {
                  state.photos.remove(photo);
                },
                canBeRemoved: (userHasEditPermission &&
                        state.photos[index].owner.id ==
                            context.read<AuthProvider>().userId) ||
                    userIsOwner,
              ),
            );
          } else if (state is PhotosDataLoadingError) {
            return TripFeatureCard(
              title: 'Photos',
              emptyMessage: state.errorMessage,
              showAddButton: userHasEditPermission,
              icon: Icons.camera_alt,
              isLoading: state is PhotosDataLoading,
              length: 0,
              type: TripFeatureCardType.grid,
              onAddTap: () {},
              itemBuilder: (context, index) => const SizedBox(),
            );
          } else if (state is PhotosDataLoading) {
            return TripFeatureCard(
              title: 'Photos',
              emptyMessage: 'Chargement des photos...',
              showAddButton: userHasEditPermission,
              icon: Icons.camera_alt,
              isLoading: true,
              length: 0,
              type: TripFeatureCardType.grid,
              onAddTap: () {},
              itemBuilder: (context, index) => const SizedBox(),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
