import 'package:flutter/cupertino.dart';
import 'package:move_together_app/core/exceptions/api_exception.dart';
import 'package:move_together_app/core/models/log.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/core/services/admin_service.dart';

part 'logs_event.dart';
part 'logs_state.dart';

class LogsBloc extends Bloc<LogsEvent, LogsState> {
  LogsBloc(BuildContext context) : super(LogsInitial()) {
    final adminServices = AdminService(context.read<AuthProvider>());

    on<LogsDataFetch>((event, emit) async {
      emit(LogsDataLoading());
      try {
        final logs = await adminServices.getAllLogs(filter: event.filter, page: event.page);
        emit(LogsDataLoadingSuccess(logs: logs));
      } on ApiException catch (error) {
        emit(LogsDataLoadingError(errorMessage: error.message));
      } catch (error) {
        emit(LogsDataLoadingError(errorMessage: 'Unhandled error'));
      }
    });
  }
}