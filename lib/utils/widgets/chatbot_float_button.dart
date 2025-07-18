import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/bloc/chatBotBloc/chatbot_bloc.dart';
import 'package:newsapp/screens/chatbot/chatbot_screen.dart';
import 'package:newsapp/main.dart'; // to get navigatorKey

class ChatBotFloatButton extends StatelessWidget {
  const ChatBotFloatButton({super.key});

  void _openChat() {
    final state = navigatorKey.currentState;
    final context = navigatorKey.currentContext;

    if (state != null && context != null) {
      final bloc = context.read<ChatBotBloc>();

      state.push(
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: bloc,
            child: const ChatBotScreen(),
          ),
        ),
      );
    } else {
      debugPrint("Navigator state or context is null.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _openChat,
      child: const Icon(Icons.chat),
    );
  }
}
