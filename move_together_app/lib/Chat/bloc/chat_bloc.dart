import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/core/exceptions/api_exception.dart';
import 'package:move_together_app/core/models/message.dart';
import 'package:move_together_app/core/services/chat_service.dart';
import '../../Provider/auth_provider.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(BuildContext context) : super(ChatInitial()) {
    final chatServices = ChatService(context.read<AuthProvider>());

    on<ChatDataFetch>((event, emit) async {
      emit(ChatDataLoading());
      try {
        final messages = await chatServices.getChatMessages(event.tripId);
        emit(ChatDataLoadingSuccess(messages: messages));
      } on ApiException catch (error) {
        emit(ChatDataLoadingError(errorMessage: error.message));
      } catch (error) {
        emit(ChatDataLoadingError(errorMessage: 'Unhandled error'));
      }
    });

    on<ChatDataSendMessage>((event, emit) async {
      final currentState = state;
      if (currentState is ChatDataLoadingSuccess) {
        emit(currentState.copyWith(sendMessageState: ChatSendMessageLoading()));
        try {
          final message = await chatServices.create(event.tripId, event.message);
          final updatedState = currentState
              .addMessage(message)
              .copyWith(sendMessageState: ChatSendMessageSuccess(message: message));
          emit(updatedState);
        } on ApiException catch (error) {
          emit(currentState.copyWith(sendMessageState: ChatSendMessageError(errorMessage: error.message)));
        } catch (error) {
          emit(currentState.copyWith(sendMessageState: ChatSendMessageError(errorMessage: 'Unhandled error')));
        }
      }
    });
  }
}
