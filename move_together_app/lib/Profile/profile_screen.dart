import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/Profile/bloc/profile_bloc.dart';
import 'package:move_together_app/router.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:move_together_app/core/services/user_service.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final ImagePicker picker = ImagePicker();
  final uuid = const Uuid();

  @override
  Widget build(BuildContext context) {
    final userService = UserService(context.read<AuthProvider>());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.error,
            ),
            onPressed: () async {
              final authProvider = context.read<AuthProvider>();
              await authProvider.logout();
              router.go('/');
            },
          ),
        ],
      ),
      body: BlocProvider(
          create: (context) => ProfileBloc(context)..add(ProfileDataLoaded()),
          child:
          BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
            if (state is ProfileDataLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ProfileDataLoadingError) {
              return Center(
                child: Text(state.errorMessage),
              );
            } else if (state is ProfileDataLoadingSuccess) {
              Future<void> handleProfilePictureUpdate() async {
                final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  await userService.uploadProfilePicture(image);
                  context.read<ProfileBloc>().add(ProfilePictureUpdated());
                }
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      state.profile.profilePicturePath != null && state.profile.profilePicturePath != ''
                          ? InkWell(
                        onTap: handleProfilePictureUpdate,
                        child: ClipOval(
                          child: Image.network(
                            '${dotenv.env['API_ADDRESS']}${state.profile.profilePictureUri}?v=${uuid.v4()}',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                          : InkWell(
                        onTap: handleProfilePictureUpdate,
                        child: Icon(
                          Icons.account_circle,
                          size: 100,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    state.profile.formattedUsername,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Role: ${state.profile.role.toString().split('.').last}',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              );
            }
            return const SizedBox();
          })),
    );
  }
}
