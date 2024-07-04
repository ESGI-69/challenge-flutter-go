import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/Document/bloc/document_bloc.dart';
import 'package:move_together_app/Transport/transport_create_modal.dart';
import 'package:move_together_app/Transport/transport_info_modal.dart';
import 'package:move_together_app/Transport/transport_row.dart';
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
      create: (context) => DocumentBloc(context)..add(DocumentsDataFetch(tripId)),
      child: BlocBuilder<DocumentBloc, DocumentState>(
        builder: (context, state) {
          if (state is DocumentsDataLoadingSuccess){
            return TripFeatureCard(
              title: 'Documents',
              emptyMessage: 'Aucun document. Appuie sur le + pour ajouter tes documents de voyage',
              showAddButton: userHasEditPermission,
              icon: Icons.folder,
              isLoading: state is DocumentsDataLoading,
              length: state.documents.length,
              onAddTap: (){
                print('add tap');
              },
              onTitleTap: () {
                print('title tap');
              },
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Text(state.documents[index].title),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        state.documents.remove(state.documents[index]);
                      },
                    )
                  ],
                );
              }
            );
          } else if (state is DocumentsDataLoading) {
            return TripFeatureCard(
              title: 'Documents',
              icon: Icons.folder,
              isLoading: true,
              length: 0,
              itemBuilder: (context, index) {
                return const SizedBox();
              }
            );
          } else if (state is DocumentsDataLoadingError){
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