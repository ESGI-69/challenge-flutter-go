part of 'logs_bloc.dart';

@immutable
sealed class LogsEvent {}

class LogsDataFetch extends LogsEvent {
  final String? filter;
  final int page;
  LogsDataFetch({this.filter, required this.page});
}