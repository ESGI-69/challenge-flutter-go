part of 'document_bloc.dart';

@immutable
sealed class DocumentState {}

final class DocumentInitial extends DocumentState {}

final class DocumentsDataLoading extends DocumentState {}

final class DocumentsDataLoadingSuccess extends DocumentState {
  final List<Document> documents;

  DocumentsDataLoadingSuccess({required this.documents});
}

final class DocumentsDataLoadingError extends DocumentState {
  final String errorMessage;

  DocumentsDataLoadingError({required this.errorMessage});
}
