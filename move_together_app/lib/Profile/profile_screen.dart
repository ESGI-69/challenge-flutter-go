import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/Profile/bloc/profile_bloc.dart';
import 'package:move_together_app/router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profil'),
        ),
        body: BlocProvider(
          create: (context) => ProfileBloc()..add(ProfileDataLoaded()),
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileDataLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is ProfileDataLoadingError) {
                return Center(
                  child: Column(
                    children: [
                      Text(state.errorMessage),
                      ElevatedButton(
                        child: const Text('Logout'),
                        onPressed: () {
                          secureStorage.delete(key: 'jwt');
                          router.go('/home');
                        },
                      ),
                    ],
                  ),
                );
              } else if (state is ProfileDataLoadingSuccess) {
                return Column(
                  children: [
                    Text(state.profile.name),
                    Text(state.profile.id.toString()),
                    Text(state.profile.role),
                    ElevatedButton(
                      child: const Text('Logout'),
                      onPressed: () {
                        secureStorage.delete(key: 'jwt');
                        router.go('/home');
                      },
                    ),
                  ],
                );
              }
              return const SizedBox();
            }
          )
        ),
      ),
    );
  }
}