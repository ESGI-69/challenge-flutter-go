import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/Profile/bloc/profile_bloc.dart';
import 'package:move_together_app/router.dart';
import 'package:move_together_app/Provider/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileDataLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ProfileDataLoadingError) {
              return Center(
                child: Text(state.errorMessage),
              );
            } else if (state is ProfileDataLoadingSuccess) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_circle,
                        size: 100,
                        color: Theme.of(context).hintColor,
                      ),
                    ],
                  ),
                  Text(
                    '@${state.profile.name}',
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
          }
        )
      ),
    );
  }
}
