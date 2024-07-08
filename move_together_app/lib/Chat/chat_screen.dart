import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/Chat/bloc/chat_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:move_together_app/Chat/chat_body.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/Widgets/Button/button_back.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tripId = GoRouterState.of(context).uri.pathSegments[1];
    final tripName = GoRouterState.of(context).uri.queryParameters['tripName'] ?? '';
    final authProvider = context.read<AuthProvider>();
    final currentUserId = authProvider.userId;

    return SafeArea(
      top: false,
      child: BlocProvider(
        create: (context) => ChatBloc(context)..add(ChatDataFetch(tripId)),
        child: BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
          if (state is ChatDataLoading) {
            return Scaffold(
              appBar: AppBar(
                title: const Text(""),
                leading: const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: ButtonBack(),
                ),
              ),
              body: const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            );
          } else if (state is ChatDataLoadingError) {
            return Center(
              child: Text(state.errorMessage),
            );
          } else if (state is ChatDataLoadingSuccess) {
            return Scaffold(
              appBar: AppBar(
                title: Text(tripName),
                leading: const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: ButtonBack(),
                ),
              ),
              body: ChatBody(
                messages: state.messages,
                tripId: tripId,
                userId: currentUserId,
                scrollController: ScrollController(),
              ),
              bottomNavigationBar: state.sendMessageState is ChatSendMessageLoading
                  ? const LinearProgressIndicator()
                  : const SizedBox(height: 4),
            );
          } else {
            return const Text('Unhandled state');
          }
        }),
      ),
    );
  }
}
