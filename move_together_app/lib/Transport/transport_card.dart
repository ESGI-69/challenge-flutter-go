import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/Transport/bloc/transport_bloc.dart';
import 'package:move_together_app/Transport/transport_row.dart';
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
          if (state is TransportsDataLoadingSuccess) {
            return TripFeatureCard(
              title: 'Transports',
              emptyMessage: 'Comment voyagerons-nous ? Appuie sur le + pour ajouter un moyen de transport',
              icon: Icons.directions_car,
              isLoading: state is TransportsDataLoading,
              length: state.transports.length,
              // ignore: avoid_print
              onAddTap: () {print('add tap');},
              // ignore: avoid_print
              onTitleTap: () {print('title tap');},
              itemBuilder: (context, index) {
                return TransportRow(transport: state.transports[index]);
              },
            );
          } else if (state is TransportsDataLoading) {
            return TripFeatureCard(
              title: 'Transports',
              emptyMessage: 'Comment voyagerons-nous ? Appuie sur le + pour ajouter un moyen de transport',
              icon: Icons.directions_car,
              isLoading: true,
              length: 0,
              itemBuilder: (context, index) {
                return const SizedBox();
              },
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