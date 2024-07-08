import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/core/models/note.dart';
import 'package:move_together_app/core/services/note_service.dart';

class NoteInfoModal extends StatelessWidget {
  final Note note;
  final bool hasTripEditPermission;
  final bool isTripOwner;
  final Function(Note) onNoteDeleted;
  final int tripId;

  const NoteInfoModal({
    super.key,
    required this.note,
    required this.hasTripEditPermission,
    required this.isTripOwner,
    required this.onNoteDeleted,
    required this.tripId,
  });


  @override
  Widget build(BuildContext context) {

    void deleteNote() async {
      await NoteService(context.read<AuthProvider>()).delete(tripId, note.id);
      onNoteDeleted(note);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _Header(),
              const SizedBox(height: 16),
              Text(
                'Titre : ${note.title}',
              ),
              const SizedBox(height: 8),
              Text(
                'Contenu : ${note.content}',
              ),
              const SizedBox(height: 16),
              (hasTripEditPermission && note.author.isMe(context)) || isTripOwner
                  ? ElevatedButton(
                onPressed: deleteNote,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Theme.of(context).colorScheme.error),
                ),
                child: const Text(
                  'Supprimer',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
                  : !hasTripEditPermission
                  ? Text(
                'Vous n\'avez pas la permission de supprimer cette note car vous ne pouvez pas modifier le voyage',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).hintColor,
                ),
              )
                  : !note.author.isMe(context)
                  ? Text(
                'Vous ne pouvez pas supprimer cette note car vous n\'êtes pas son créateur',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).hintColor,
                ),
              )
                  : const SizedBox(),
            ]
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16,
      ),
      child: Column(
        children: [
          const SizedBox(height: 4),
          Container(
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 4),
          const Row(
            children: [
              Expanded(child:
              Text(
                'Informations de la note',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              )
            ],
          ),
        ],
      ),
    );
  }
}