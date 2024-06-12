import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/Home/blocs/home_bloc.dart';
import 'package:move_together_app/Home/empty_home.dart';
import 'package:move_together_app/router.dart';

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
    return SafeArea(
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
                return Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                  child: Flex(
                    direction: Axis.vertical,
                    children: <Widget>[
                    Expanded(
                      child: PageView(
                      onPageChanged: changePage,
                      children: state.trips.map((trip) {
                        return Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Container(
                          color: Colors.blue,
                          child: Center(
                          child: Text(trip.name),
                          ),
                        ),
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
            color: widget.currentIndex == index ? Colors.blue : Colors.grey,
          ),
        );
      }),
    );
  }
}
