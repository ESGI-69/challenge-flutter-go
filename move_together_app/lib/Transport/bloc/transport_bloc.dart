import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/core/exceptions/api_exception.dart';
import 'package:move_together_app/core/models/transport.dart';
import 'package:move_together_app/core/services/transport_service.dart';
import 'package:move_together_app/utils/exception_to_string.dart';

part 'transport_event.dart';
part 'transport_state.dart';

class TransportBloc extends Bloc<TransportEvent, TransportState> {
  TransportBloc(BuildContext context) : super(TransportInitial()) {
    final apiServices = TransportService(context.read<AuthProvider>());
    on<TransportsDataFetch>((event, emit) async {
      emit(TransportsDataLoading());

      try {
        final transports = await apiServices.getAll(event.tripId);
        emit(TransportsDataLoadingSuccess(transports: transports));
      } on ApiException catch (error) {
        emit(TransportsDataLoadingError(errorMessage: error.message));
      } catch (error) {
        emit(
            TransportsDataLoadingError(errorMessage: exceptionToString(error)));
      }
    });
  }
}
