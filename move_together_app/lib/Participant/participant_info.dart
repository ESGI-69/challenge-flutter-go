import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:move_together_app/Participant/bloc/participant_bloc.dart';
import 'package:move_together_app/Participant/participant_add_modal.dart';
import 'package:move_together_app/Participant/participant_row.dart';
import 'package:move_together_app/core/models/participant.dart';

class ParticipantInfo extends StatelessWidget {
  final int tripId;
  final String inviteCode;

  const ParticipantInfo({
    super.key,
    required this.tripId,
    required this.inviteCode,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      ParticipantBloc(context)..add(ParticipantDataFetch(tripId)),
      child: BlocBuilder<ParticipantBloc, ParticipantState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              leading: const SizedBox(),
              actions: [
                TextButton(
                  onPressed: Navigator.of(context).pop,
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                )
              ],
              title: const Text('Participants'),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                await showCupertinoModalBottomSheet(
                  expand: true,
                  context: context,
                  builder: (BuildContext context) => ParticipantAddModal(
                    inviteCode: inviteCode,
                  ),
                );

                context.read<ParticipantBloc>().add(ParticipantDataFetch(
                  tripId,
                ));
              },
              shape: const CircleBorder(),
              child: const Icon(Icons.add),
            ),
            body: Center(
              child: _buildBody(context, state),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, ParticipantState state) {
    if (state is ParticipantDataLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (state is ParticipantDataLoadingError) {
      return Center(
        child: Text(state.errorMessage),
      );
    } else if (state is ParticipantDataLoadingSuccess) {
      final me = state.participants.firstWhere(
              (participant) => participant.isMe(context),
          orElse: () => Participant(
              id: -1,
              username: '',
              tripRole: ParticipantTripRole.VIEWER));
      final iAmTheOwner =
          me.tripRole == ParticipantTripRole.OWNER;

      return ListView.builder(
        itemCount: state.participants.length,
        itemBuilder: (context, index) {
          final participant = state.participants[index];

          return ParticipantRow(
            participant: participant,
            showTrailingButton: iAmTheOwner,
            tripId: tripId,
            onAction: () {
              context
                  .read<ParticipantBloc>()
                  .add(ParticipantDataFetch(tripId));
            },
          );
        },
      );
    }
    return const SizedBox();
  }
}
