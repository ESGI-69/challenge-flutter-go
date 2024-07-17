import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:move_together_app/Note/bloc/note_bloc.dart';
import 'package:move_together_app/Note/note_create_modal.dart';
import 'package:move_together_app/Note/note_row.dart';
import 'package:move_together_app/Widgets/Card/trip_feature_card.dart';

class NoteCard extends StatelessWidget {
  final int tripId;
  final bool userHasEditPermission;
  final bool userIsOwner;

  const NoteCard({
    super.key,
    required this.tripId,
    required this.userHasEditPermission,
    required this.userIsOwner,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => NoteBloc(context)..add(NotesDataFetch(tripId)),
        child: BlocBuilder<NoteBloc, NoteState>(builder: (context, state) {
          if (state is NotesDataLoadingSuccess) {
            return TripFeatureCard(
              title: 'Notes',
              emptyMessage:
                  'Tellement vide ! Appuie sur le + pour ajouter des notes',
              showAddButton: userHasEditPermission,
              icon: Icons.note,
              isLoading: state is NotesDataLoading,
              length: state.notes.length,
              onAddTap: () {
                showCupertinoModalBottomSheet(
                  expand: true,
                  context: context,
                  builder: (BuildContext context) => NoteCreateModal(
                    tripId: tripId,
                    onNoteCreated: (createdNote) {
                      state.notes.add(createdNote);
                      Navigator.of(context).pop();
                    },
                  ),
                );
              },
              itemBuilder: (context, index) {
                return NoteRow(
                  note: state.notes[index],
                  onTap: () async {
                    await context.pushNamed(
                      'note',
                      pathParameters: {
                        'tripId': tripId.toString(),
                        'noteId': state.notes[index].id.toString(),
                      },
                      queryParameters: {
                        'hasTripEditPermission':
                            userHasEditPermission.toString(),
                        'isOwner': userIsOwner.toString(),
                      },
                      extra: state.notes[index],
                    );
                  },
                );
              },
            );
          } else if (state is NotesDataLoading) {
            return TripFeatureCard(
              title: 'Notes',
              emptyMessage:
                  'Tellement vide ! Appuie sur le + pour ajouter des notes',
              showAddButton: false,
              icon: Icons.note,
              isLoading: true,
              length: 0,
              itemBuilder: (context, index) {
                return const SizedBox();
              },
            );
          } else if (state is NotesDataLoadingError) {
            return Center(
              child: Column(
                children: [
                  Text(state.errorMessage),
                ],
              ),
            );
          }
          return const SizedBox();
        }));
  }
}
