import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/core/exceptions/api_exception.dart';
import 'package:move_together_app/core/models/document.dart';
import 'package:move_together_app/core/services/document_service.dart';
import 'package:move_together_app/utils/exception_to_string.dart';

part 'document_event.dart';
part 'document_state.dart';

class DocumentBloc extends Bloc<DocumentEvent, DocumentState> {
  DocumentBloc(BuildContext context) : super(DocumentInitial()) {
    final apiServices = DocumentService(context.read<AuthProvider>());
    on<DocumentsDataFetch>((event, emit) async {
      emit(DocumentsDataLoading());

      try {
        final documents = await apiServices.getAll(event.tripId);
        emit(DocumentsDataLoadingSuccess(documents: documents));
      } on ApiException catch (error) {
        emit(DocumentsDataLoadingError(errorMessage: error.message));
      } catch (error) {
        emit(DocumentsDataLoadingError(errorMessage: exceptionToString(error)));
      }
    });
  }
}
