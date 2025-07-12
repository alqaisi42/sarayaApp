import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/chatBotBloc/chatbot_bloc.dart';
import '../../screens/chatbot/chatbot_screen.dart';

class ChatBotFloatButton extends StatelessWidget {
  const ChatBotFloatButton({super.key});

  void _openChat(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<ChatBotBloc>(),
          child: const ChatBotScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _openChat(context),
      child: const Icon(Icons.chat),
    );
  }
}

