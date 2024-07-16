part of 'logs_bloc.dart';

@immutable
sealed class LogsState {}

final class LogsInitial extends LogsState {}

final class LogsDataLoading extends LogsState {}

final class LogsDataLoadingSuccess extends LogsState {
  final List<Log> logs;

  LogsDataLoadingSuccess({required this.logs});
}

final class LogsDataLoadingError extends LogsState {
  final String errorMessage;

  LogsDataLoadingError({required this.errorMessage});
}
