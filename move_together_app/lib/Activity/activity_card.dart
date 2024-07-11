import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
  final Function() onRefresh;

  const ActivityCard({
    super.key,
    required this.tripId,
    required this.userHasEditPermission,
    required this.userIsOwner,
    required this.onRefresh,
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
                  emptyMessage: 'Qu\'allons-nous faire ? Appuie sur le + pour ajouter des activités',
                  showAddButton: userHasEditPermission,
                  icon: Icons.kayaking,
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
                          context.pop();
                          onRefresh();
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
                            onActivityDeleted: (note) {
                              state.activities.remove(note);
                              context.pop();
                              onRefresh();
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
                  emptyMessage: 'Qu\'allons-nous faire ? Appuie sur le + pour ajouter des activités',
                  showAddButton: false,
                  icon: Icons.kayaking,
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