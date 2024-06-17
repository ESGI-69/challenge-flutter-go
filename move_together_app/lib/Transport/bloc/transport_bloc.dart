import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/core/exceptions/api_exception.dart';
import 'package:move_together_app/core/models/Transport.dart';
import 'package:move_together_app/core/services/api_services.dart';

part 'transport_event.dart';
part 'transport_state.dart';

class TransportBloc extends Bloc<TransportEvent, TransportState> {
  TransportBloc(BuildContext context) : super(TransportInitial()) {
    on<TransportsDataFetch>((event, emit) async {
      emit(TransportsDataLoading());
      final apiServices = ApiServices(context.read<AuthProvider>());

      try {
        final transports = await apiServices.getTransports(event.tripId);
        print(transports);
        emit(TransportsDataLoadingSuccess(transports: transports));
      } on ApiException catch (error) {
        emit(TransportsDataLoadingError(errorMessage: error.message));
      } catch (error) {
        print(error);
        emit(TransportsDataLoadingError(errorMessage: 'Unhandled error'));
      }
    });
  }
}
