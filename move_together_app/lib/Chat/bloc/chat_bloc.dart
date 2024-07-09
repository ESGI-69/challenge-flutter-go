import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:move_together_app/core/exceptions/api_exception.dart';
import 'package:move_together_app/core/models/message.dart';
import 'package:move_together_app/core/services/chat_service.dart';
import 'package:move_together_app/core/services/websocket_service.dart';
import '../../Provider/auth_provider.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatService _chatService;
  final WebSocketService _webSocketService;

  ChatBloc(BuildContext context, String tripId)
      : _chatService = ChatService(context.read<AuthProvider>()),
        _webSocketService = WebSocketService(dotenv.env['WEBSOCKET_ADDRESS']!, 'chat_$tripId'),
        super(ChatInitial()) {
    on<ChatDataFetch>(_onChatDataFetch);
    on<ChatDataSendMessage>(_onChatDataSendMessage);
    on<ChatDataReceived>(_onChatDataReceived);

    // Listen to messages from WebSocketService
    _webSocketService.stream.listen((message) {
      add(ChatDataReceived(message));
    });
  }

  void _onChatDataFetch(ChatDataFetch event, Emitter<ChatState> emit) async {
    emit(ChatDataLoading());
    try {
      final messages = await _chatService.getChatMessages(event.tripId);
      emit(ChatDataLoadingSuccess(messages: messages));
    } on ApiException catch (error) {
      emit(ChatDataLoadingError(errorMessage: error.message));
    } catch (error) {
      emit(ChatDataLoadingError(errorMessage: 'Unhandled error'));
    }
  }

  void _onChatDataSendMessage(ChatDataSendMessage event, Emitter<ChatState> emit) async {
    final currentState = state;
    if (currentState is ChatDataLoadingSuccess) {
      emit(currentState.copyWith(sendMessageState: ChatSendMessageLoading()));
      try {
        await _chatService.create(event.tripId, event.message);
      } on ApiException catch (error) {
        emit(currentState.copyWith(sendMessageState: ChatSendMessageError(errorMessage: error.message)));
      } catch (error) {
        emit(currentState.copyWith(sendMessageState: const ChatSendMessageError(errorMessage: 'Unhandled error')));
      }
    }
  }

  void _onChatDataReceived(ChatDataReceived event, Emitter<ChatState> emit) {
    final currentState = state;
    if (currentState is ChatDataLoadingSuccess) {
      final messageDecoded = jsonDecode(event.message);
      final message = Message.fromJson(messageDecoded);
      final updatedState = currentState
          .addMessage(message)
          .copyWith(sendMessageState: ChatSendMessageSuccess(message: message));
      emit(updatedState);
    }
  }

  @override
  Future<void> close() {
    _webSocketService.close();
    return super.close();
  }
}
