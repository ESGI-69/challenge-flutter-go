import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:move_together_app/Activity/bloc/activity_bloc.dart';
import 'package:move_together_app/Activity/activity_create_modal.dart';
import 'package:move_together_app/Activity/activity_info_modal.dart';
import 'package:move_together_app/Activity/activity_row.dart';
import 'package:move_together_app/Widgets/Card/trip_feature_card.dart';

class ActivityCard extends StatelessWidget {
  final int tripId;
  final bool userHasEditPermission;
  final bool userIsOwner;

  const ActivityCard({
    super.key,
    required this.tripId,
    required this.userHasEditPermission,
    required this.userIsOwner,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ActivityBloc(context)..add(ActivitiesDataFetch(tripId)),
        child: BlocBuilder<ActivityBloc, ActivityState>(
            builder: (context, state) {
              if (state is ActivitiesDataLoadingSuccess) {
                return TripFeatureCard(
                  title: 'Activities',
                  emptyMessage: 'Tellement vide ! Appuie sur le + pour ajouter des notes',
                  showAddButton: userHasEditPermission,
                  icon: Icons.note,
                  isLoading: state is ActivitiesDataLoading,
                  length: state.activities.length,
                  onAddTap: () {
                    showCupertinoModalBottomSheet(
                      expand: true,
                      context: context,
                      builder: (BuildContext context) => ActivityCreateModal(
                        tripId: tripId,
                        onActivityCreated: (createdActivity) {
                          state.activities.add(createdActivity);
                          Navigator.of(context).pop();
                        },
                      ),
                    );
                  },
                  itemBuilder: (context, index) {
                    return ActivityRow(
                      activity: state.activities[index],
                      onTap: () => showCupertinoModalBottomSheet(
                        expand: true,
                        context: context,
                        builder: (BuildContext context) => ActivityInfoModal(
                            activity: state.activities[index],
                            hasTripEditPermission: userHasEditPermission,
                            isTripOwner: userIsOwner,
                            onActivityDeleted: (note) => {
                              state.activities.remove(note),
                              Navigator.of(context).pop(),
                            },
                            tripId: tripId
                        ),
                      ),
                    );
                  },
                );
              } else if (state is ActivitiesDataLoading) {
                return TripFeatureCard(
                  title: 'Activities',
                  emptyMessage: 'Tellement vide ! Appuie sur le + pour ajouter des notes',
                  showAddButton: false,
                  icon: Icons.note,
                  isLoading: true,
                  length: 0,
                  itemBuilder: (context, index) {
                    return const SizedBox();
                  },
                );
              } else if (state is ActivitiesDataLoadingError) {
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