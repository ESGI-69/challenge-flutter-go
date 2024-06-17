import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/Transport/bloc/transport_bloc.dart';
import 'package:move_together_app/Widgets/Card/trip_feature_card.dart';

class TransportCard extends StatelessWidget {
  final String tripId;

  const TransportCard({
    required this.tripId,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransportBloc(context)..add(TransportsDataFetch(tripId)),
      child: BlocBuilder<TransportBloc, TransportState>(
        builder: (context, state) {
          if (state is TransportsDataLoading || state is TransportsDataLoadingSuccess) {
            return TripFeatureCard(
              title: 'Transports',
              icon: Icons.directions_car,
              isLoading: state is TransportsDataLoading,
              length: state is TransportsDataLoadingSuccess ? state.transports.length : 0,
              child: state is TransportsDataLoadingSuccess
                ? Column(
                  children: [
                    for (final transport in state.transports)
                      Text(transport.startAddress),
                  ],
                )
                : const SizedBox(),
            );
          } else if (state is TransportsDataLoadingError) {
            return Center(
              child: Column(
                children: [
                  Text(state.errorMessage),
                ],
              ),
            );
          }
          return const SizedBox();
        }
      )
    );
  }
}