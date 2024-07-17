import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:move_together_app/Document/bloc/document_bloc.dart';
import 'package:move_together_app/Document/document_create_modal.dart';
import 'package:move_together_app/Document/document_row.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:move_together_app/Widgets/Card/trip_feature_card.dart';

class DocumentCard extends StatelessWidget {
  final int tripId;
  final bool userHasEditPermission;
  final bool userIsOwner;

  const DocumentCard({
    super.key,
    required this.tripId,
    required this.userHasEditPermission,
    required this.userIsOwner,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            DocumentBloc(context)..add(DocumentsDataFetch(tripId)),
        child:
            BlocBuilder<DocumentBloc, DocumentState>(builder: (context, state) {
          if (state is DocumentsDataLoadingSuccess) {
            return TripFeatureCard(
                title: 'Documents',
                emptyMessage:
                    'Aucun document. Appuie sur le + pour ajouter tes documents de voyage',
                showAddButton: userHasEditPermission,
                icon: Icons.folder,
                isLoading: state is DocumentsDataLoading,
                length: state.documents.length,
                onAddTap: () {
                  showCupertinoModalBottomSheet(
                      expand: true,
                      context: context,
                      builder: (BuildContext context) => DocumentCreateModal(
                            tripId: tripId,
                            onDocumentCreated: (createdDocument) {
                              state.documents.add(createdDocument);
                              Navigator.of(context).pop();
                            },
                          ));
                },
                itemBuilder: (context, index) {
                  return DocumentRow(
                      document: state.documents[index],
                      onTap: () async {
                        await context.pushNamed(
                          'document',
                          pathParameters: {
                            'tripId': tripId.toString(),
                            'documentId': state.documents[index].id.toString(),
                          },
                          queryParameters: {
                            'hasTripEditPermission':
                                userHasEditPermission.toString(),
                            'isTripOwner': userIsOwner.toString(),
                          },
                          extra: state.documents[index],
                        );
                        context
                            .read<DocumentBloc>()
                            .add(DocumentsDataFetch(tripId));
                      });
                });
          } else if (state is DocumentsDataLoading) {
            return TripFeatureCard(
                title: 'Documents',
                icon: Icons.folder,
                isLoading: true,
                length: 0,
                itemBuilder: (context, index) {
                  return const SizedBox();
                });
          } else if (state is DocumentsDataLoadingError) {
            return TripFeatureCard(
                title: 'Documents',
                emptyMessage: state.errorMessage,
                showAddButton: userHasEditPermission,
                icon: Icons.folder,
                isLoading: state is DocumentsDataLoading,
                length: 0,
                itemBuilder: (context, index) {
                  return const SizedBox();
                });
          }
          return const SizedBox();
        }));
  }
}
