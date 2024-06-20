import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/core/exceptions/api_exception.dart';
import 'package:move_together_app/core/models/message.dart';
import 'package:move_together_app/core/services/chat_service.dart';
import '../../Provider/auth_provider.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(BuildContext context) : super (ChatInitial()) {
    on<ChatDataFetch>((event, emit) async {
      emit(ChatDataLoading());
      final apiServices = ChatService(context.read<AuthProvider>());
      try {
        final messages = await apiServices.getChatMessages(event.tripId);
        emit(ChatDataLoadingSuccess(messages: messages));
      } on ApiException catch (error) {
        emit(ChatDataLoadingError(errorMessage: error.message));
      } catch (error) {
        emit(ChatDataLoadingError(errorMessage: 'Unhandled error'));
      }
    });
  }
}