import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:move_together_app/Photo/bloc/photo_bloc.dart';
import 'package:move_together_app/Photo/photo_item.dart';
import 'package:move_together_app/Provider/auth_provider.dart';

class PhotosScreen extends StatelessWidget {
  const PhotosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tripId = int.parse(GoRouterState.of(context).uri.pathSegments[0]);
    final hasEditPermission =
        GoRouterState.of(context).uri.queryParameters['hasEditPermission'] ==
            'true';
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Photos'),
        ),
        body: BlocProvider(
          create: (context) => PhotoBloc(context)..add(PhotosDataFetch(tripId)),
          child: BlocBuilder<PhotoBloc, PhotoState>(
            builder: (context, state) {
              if (state is PhotosDataLoadingSuccess) {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 1,
                    mainAxisSpacing: 1,
                  ),
                  itemCount: state.photos.length,
                  itemBuilder: (context, index) {
                    final photo = state.photos[index];
                    return PhotoItem(
                      tripId: tripId,
                      photo: photo,
                      onDeleteSuccess: (photo) {
                        state.photos.remove(photo);
                        if (state.photos.isEmpty) {
                          context.pop();
                        }
                      },
                      canBeRemoved: hasEditPermission &&
                          photo.owner.id == context.read<AuthProvider>().userId,
                    );
                  },
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ));
  }
}
