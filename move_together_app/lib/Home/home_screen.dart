import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:move_together_app/Home/blocs/home_bloc.dart';
import 'package:move_together_app/Home/empty_home.dart';
import 'package:move_together_app/Trip/trip_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void changePage(newPageIndex) {
    setState(() {
      _currentIndex = newPageIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.transparent,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        context.push('/join-trip');
        },
        child: const Icon(Icons.add),
      ),
      body: BlocProvider(
        create: (context) => HomeBloc(context)..add(HomeDataFetch()),
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
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Flex(
                  direction: Axis.vertical,
                  children: <Widget>[
                  Expanded(
                    child: PageView(
                    onPageChanged: changePage,
                    children: state.trips.map((trip) {
                      return TripCard(
                        onTap: () => context.push('/trip/${trip.id}', extra: trip),
                        onLeave: () => context.read<HomeBloc>().add(HomeDataLeaveTrip(trip)),
                        onDelete: () => context.read<HomeBloc>().add(HomeDataDeleteTrip(trip)),
                        imageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a8/Tour_Eiffel_Wikimedia_Commons.jpg/260px-Tour_Eiffel_Wikimedia_Commons.jpg",
                        name: trip.name,
                        startDate: trip.startDate,
                        endDate: trip.endDate,
                        participants: trip.participants,
                        isCurrentUserOwner: trip.isCurrentUserOwner(context),
                      );
                    }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  PageIndicator(
                    currentIndex: _currentIndex,
                    pageCount: state.trips.length,
                  ),
                  ],
                ),
              );
            }
            return const SizedBox();
          }
        )
      ),
    );
  }
}

class PageIndicator extends StatefulWidget {
  final int currentIndex;
  final int pageCount;

  const PageIndicator({super.key, required this.currentIndex, required this.pageCount});

  @override
  State<PageIndicator> createState() => _PageIndicatorState();
}

class _PageIndicatorState extends State<PageIndicator> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.pageCount, (index) {
        return Container(
          width: 8.0,
          height: 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.currentIndex == index ? Theme.of(context).primaryColor : Colors.grey,
          ),
        );
      }),
    );
  }
}
