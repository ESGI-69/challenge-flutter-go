import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:move_together_app/Photo/bloc/photo_bloc.dart';
import 'package:move_together_app/Photo/photo_item.dart';
import 'package:move_together_app/Widgets/Card/trip_feature_card.dart';

class PhotoCard extends StatelessWidget {
  final int tripId;
  final bool userHasEditPermission;
  final bool userIsOwner;

  PhotoCard({
    super.key,
    required this.tripId,
    required this.userHasEditPermission,
    required this.userIsOwner,
  });

  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
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
              length: state.photos.length,
              isFullGridView: true,
              onAddTap: () async {
                final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                print(image);
              },
              itemBuilder: (context, index) => PhotoItem(photoUrl: '${dotenv.env['API_ADDRESS']}/trips/$tripId/photos/${state.photos[index].id}/download'),
            );
          } else if (state is PhotosDataLoadingError) {
            return TripFeatureCard(
              title: 'Photos',
              emptyMessage: state.errorMessage,
              showAddButton: userHasEditPermission,
              icon: Icons.camera_alt,
              isLoading: state is PhotosDataLoading,
              length: 0,
              isFullGridView: true,
              onAddTap: () async {
                final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                print(image);
              },
              itemBuilder: (context, index) => const PhotoItem(photoUrl: ''),
            );
          } else if (state is PhotosDataLoading) {
            return TripFeatureCard(
              title: 'Photos',
              emptyMessage: 'Chargement des photos...',
              showAddButton: userHasEditPermission,
              icon: Icons.camera_alt,
              isLoading: true,
              length: 0,
              isFullGridView: true,
              onAddTap: () async {
                final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                print(image);
              },
              itemBuilder: (context, index) => const PhotoItem(photoUrl: ''),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}