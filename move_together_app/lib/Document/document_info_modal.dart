import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/core/models/document.dart';
import 'package:move_together_app/core/services/document_service.dart';
import 'package:open_file/open_file.dart';

class DocumentInfoModal extends StatelessWidget {
  final Document document;
  final bool hasTripEditPermission;
  final bool isTripOwner;
  final Function(Document) onDocumentDeleted;
  final int tripId;

  const DocumentInfoModal({
    super.key,
    required this.document,
    required this.hasTripEditPermission,
    required this.isTripOwner,
    required this.onDocumentDeleted,
    required this.tripId,
  });

  @override
  Widget build(BuildContext context) {
    void deleteDocument() async {
      await DocumentService(context.read<AuthProvider>())
          .delete(tripId, document.id);
      onDocumentDeleted(document);
    }

    void downloadDocument() async {
      final documentPath = await DocumentService(context.read<AuthProvider>()).download(tripId, document.id);
        final result = await OpenFile.open(documentPath);
        if (result.type != ResultType.done) {
          print('Erreur lors de l\'ouverture du document');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erreur lors de l\'ouverture du document')),
          );
        }
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
              'Titre du document : ${document.title}',
            ),
            const SizedBox(height: 8),
            Text(
              'Description : ${document.description}',
            ),
            const SizedBox(height: 8),
            Text(
              'Créé le : ${DateFormat.yMMMd().format(document.createdAt.toLocal())}',
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: downloadDocument,
              child: const Text('Voir le document'),
            ),
            const SizedBox(height: 32),
            (hasTripEditPermission || isTripOwner)
                ? ElevatedButton(
                    onPressed: deleteDocument,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(Theme.of(context).colorScheme.error),
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
      )
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
        child: Column(children: [
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
              Expanded(
                child: Text(
                  'Informations du document',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ]));
  }
}
