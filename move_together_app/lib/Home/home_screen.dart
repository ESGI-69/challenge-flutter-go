import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/Home/blocs/home_bloc.dart';
import 'package:move_together_app/Home/empty_home.dart';
import 'package:move_together_app/router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
          router.go('/join-trip');
          },
          child: const Icon(Icons.add),
        ),
        body: BlocProvider(
          create: (context) => HomeBloc()..add(HomeDataLoaded()),
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeDataLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is HomeDataLoadingError) {
                return Center(
                  child: Text(state.errorMessage),
                );
              } else if (state is HomeDataLoadingSuccess) {
                if (state.trips.isEmpty) {
                  return const EmptyHome();
                }
                return ListView.builder(
                  itemCount: state.trips.length,
                  itemBuilder: (context, index) {
                    final trip = state.trips[index];
                    return ListTile(
                      title: Text(trip.name),
                      subtitle: Text(trip.city),
                    );
                  },
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
