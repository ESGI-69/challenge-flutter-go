import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/Chat/bloc/chat_bloc.dart';
import 'package:move_together_app/Chat/chat_app_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:move_together_app/Chat/chat_body.dart';
import 'package:move_together_app/Provider/auth_provider.dart';

class ChatScreen extends StatelessWidget {

  const ChatScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final tripId = GoRouterState.of(context).uri.pathSegments[1];
    final tripName = GoRouterState.of(context).uri.queryParameters['tripName'] ?? '';
    final authProvider = context.read<AuthProvider>();
    final currentUserId = authProvider.userId;


    return BlocProvider(
      create: (context) => ChatBloc(context)..add(ChatDataFetch(tripId)),
      child: BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
        if (state is ChatDataLoading) {
          return const Scaffold(
            appBar: ChatAppBar(
              tripName: '',
            ),
            body: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        } else if (state is ChatDataLoadingError) {
          return Center(
            child: Text(state.errorMessage),
          );
        } else if (state is ChatDataLoadingSuccess) {
          return Scaffold(
            appBar: ChatAppBar(
              tripName: tripName,
            ),
            body: ChatBody(
              messages: state.messages,
              userId: currentUserId,
              scrollController: ScrollController(),
            )
          );
        }
        {
          return const Text('Unhandled state');
        }
      })
    );
  }
}
