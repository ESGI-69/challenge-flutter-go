import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:move_together_app/Accommodation/bloc/accommodation_bloc.dart';
import 'package:move_together_app/Accommodation/accommodation_create_modal.dart';
import 'package:move_together_app/Accommodation/accommodation_row.dart';
import 'package:move_together_app/Widgets/Card/trip_feature_card.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AccommodationCard extends StatelessWidget {
  final int tripId;
  final bool userHasEditPermission;
  final bool userIsOwner;
  final Function() onRefresh;

  const AccommodationCard({
    super.key,
    required this.tripId,
    required this.userHasEditPermission,
    required this.userIsOwner,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            AccommodationBloc(context)..add(AccommodationsDataFetch(tripId)),
        child: BlocBuilder<AccommodationBloc, AccommodationState>(
            builder: (context, state) {
          if (state is AccommodationsDataLoadingSuccess) {
            return TripFeatureCard(
              title: 'Hébergements',
              emptyMessage:
                  'Où on dormira ? Appuie sur le + pour ajouter un logement',
              showAddButton: userHasEditPermission,
              icon: Icons.home,
              isLoading: state is AccommodationsDataLoading,
              length: state.accommodations.length,
              onAddTap: () {
                showCupertinoModalBottomSheet(
                  expand: true,
                  context: context,
                  builder: (BuildContext context) => AccommodationCreateModal(
                    tripId: tripId,
                    onAccommodationCreated: (createdAccommodation) {
                      state.accommodations.add(createdAccommodation);
                      context.pop();
                      onRefresh();
                    },
                  ),
                );
              },
              itemBuilder: (context, index) {
                return AccommodationRow(
                  accommodation: state.accommodations[index],
                  onTap: () async {
                    await context.pushNamed(
                      'accommodation',
                      pathParameters: {
                        'tripId': tripId.toString(),
                        'accommodationId':
                            state.accommodations[index].id.toString(),
                      },
                      queryParameters: {
                        'hasTripEditPermission':
                            userHasEditPermission.toString(),
                        'isTripOwner': userIsOwner.toString(),
                      },
                      extra: state.accommodations[index],
                    );
                    context
                        .read<AccommodationBloc>()
                        .add(AccommodationsDataFetch(tripId));
                    onRefresh();
                  },
                );
              },
            );
          } else if (state is AccommodationsDataLoading) {
            return TripFeatureCard(
              title: 'Accommodations',
              emptyMessage:
                  'Comment on va dormir ? Appuie sur le + pour ajouter un logement',
              showAddButton: false,
              icon: Icons.home,
              isLoading: true,
              length: 0,
              itemBuilder: (context, index) {
                return const SizedBox();
              },
            );
          } else if (state is AccommodationsDataLoadingError) {
            return TripFeatureCard(
              title: 'Accommodations',
              emptyMessage: state.errorMessage,
              showAddButton: userHasEditPermission,
              icon: Icons.home,
              isLoading: state is AccommodationsDataLoading,
              length: 0,
              itemBuilder: (context, index) {
                return const SizedBox();
              },
            );
          }
          return const SizedBox();
        }));
  }
}
