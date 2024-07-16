import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:move_together_app/Home/blocs/home_bloc.dart';
import 'package:move_together_app/Home/empty_home.dart';
import 'package:move_together_app/Participant/participant_info.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/Trip/trip_card.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:move_together_app/core/services/trip_service.dart';

import '../Widgets/bottom_sheet_buttons.dart';
import '../Widgets/button.dart';

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
    final tripService = TripService(context.read<AuthProvider>());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          color: Theme.of(context).primaryColor,
          onPressed: () {
            context.pushNamed('profile');
          },
          icon: const Icon(
            Icons.person
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showBottomSheetButtons(context, [
            ButtonSheetButton(
              text: 'Rejoindre un voyage',
              onPressed: () => context.pushNamed('join'),
            ),
            ButtonSheetButton(
              text: 'Créer un voyage',
              onPressed: () => context.pushNamed('create'),
            ),
          ]);
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: BlocProvider(
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
                          tripId: trip.id,
                          onTap: () async {
                            await context.pushNamed('trip', pathParameters: {'tripId': trip.id.toString()});
                            context.read<HomeBloc>().add(HomeDataFetchSingleTrip(trip.id));
                          },
                          onLeave: () => context.read<HomeBloc>().add(HomeDataLeaveTrip(trip)),
                          onDelete: () => context.read<HomeBloc>().add(HomeDataDeleteTrip(trip)),
                          imageUrl:  "${dotenv.env['API_ADDRESS']}/trips/${trip.id}/banner/download",
                          name: trip.name,
                          country: trip.country,
                          city: trip.city,
                          startDate: trip.startDate,
                          endDate: trip.endDate,
                          inviteCode: trip.inviteCode,
                          participants: trip.participants,
                          isCurrentUserOwner: trip.isCurrentUserOwner(context),
                          onParticipantsTap: () async {
                            await showCupertinoModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) => ParticipantInfo(
                                tripId: trip.id,
                                inviteCode: trip.inviteCode,
                              )
                            );
                            state.trips[_currentIndex] = await tripService.get(trip.id.toString());
                          },
                          totalPrice: trip.totalPrice,
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
