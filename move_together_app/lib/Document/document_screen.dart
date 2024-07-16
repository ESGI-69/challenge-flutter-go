import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/Widgets/details_list.dart';
import 'package:move_together_app/core/models/document.dart';
import 'package:move_together_app/core/services/document_service.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';

class DocumentScreen extends StatelessWidget {
  const DocumentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final document = GoRouterState.of(context).extra as Document;

    final tripId =
        int.parse(GoRouterState.of(context).pathParameters['tripId']!);

    final hasTripEditPermission = GoRouterState.of(context)
            .uri
            .queryParameters['hasTripEditPermission'] ==
        'true';
    final isTripOwner =
        GoRouterState.of(context).uri.queryParameters['isTripOwner'] == 'true';

    void deleteDocument() async {
      await DocumentService(context.read<AuthProvider>())
          .delete(tripId, document.id);
      context.pop();
    }

    void downloadDocument() async {
      final documentPath = await DocumentService(context.read<AuthProvider>())
          .download(tripId, document.id, document.title);
      final result = await OpenFile.open(documentPath, type: 'application/pdf');
      if (result.type != ResultType.done) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Erreur lors de l\'ouverture du document')),
        );
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Document'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                DetailsList(items: [
                  DetailItem(title: 'Nom', value: document.title),
                  DetailItem(title: 'Description', value: document.description),
                  DetailItem(
                      title: 'Date de création', value: document.createdAt),
                  DetailItem(
                      title: 'Créé par',
                      value: document.owner.formattedUsername),
                ]),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: downloadDocument,
                  child: const Text('Voir le document'),
                ),
                const SizedBox(height: 8),
                (hasTripEditPermission || isTripOwner)
                    ? ElevatedButton(
                        onPressed: deleteDocument,
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                              Theme.of(context).colorScheme.error),
                        ),
                        child: const Text(
                          'Supprimer le document',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      )
                    : !hasTripEditPermission
                        ? Text(
                            'Vous n\'avez pas la permission de supprimer ce document',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).hintColor,
                            ),
                          )
                        : const SizedBox(),
              ],
            ),
          ),
        ));
  }
}
