import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/Widgets/details_list.dart';
import 'package:move_together_app/core/models/note.dart';
import 'package:move_together_app/core/services/note_service.dart';
import 'package:move_together_app/utils/exception_to_string.dart';

import 'package:move_together_app/Widgets/button.dart';

class NoteScreen extends StatelessWidget {
  const NoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final note = GoRouterState.of(context).extra as Note;

    final tripId =
        int.parse(GoRouterState.of(context).pathParameters['tripId']!);

    final hasTripEditPermission = GoRouterState.of(context)
            .uri
            .queryParameters['hasTripEditPermission'] ==
        'true';
    final isTripOwner =
        GoRouterState.of(context).uri.queryParameters['isTripOwner'] == 'true';

    void deleteNote() async {
      try {
        await NoteService(context.read<AuthProvider>()).delete(tripId, note.id);
        context.pop();
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(exceptionToString(error)),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Note'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              DetailsList(items: [
                DetailItem(title: 'Titre', value: note.title),
                DetailItem(title: 'Contenu', value: note.content),
                DetailItem(title: 'Date de création', value: note.createdAt),
                DetailItem(
                    title: 'Créé par', value: note.author.formattedUsername),
              ]),
              const SizedBox(height: 16),
              (hasTripEditPermission && note.author.isMe(context)) ||
                      isTripOwner
                  ? ElevatedButton(
                      onPressed: deleteNote,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                            Theme.of(context).colorScheme.error),
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
            ],
          ),
        ),
      ),
    );
  }
}
