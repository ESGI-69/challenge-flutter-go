part of 'document_bloc.dart';

@immutable
sealed class DocumentEvent {}

final class DocumentsDataFetch extends DocumentEvent {
  final int tripId;

  DocumentsDataFetch(this.tripId);
}