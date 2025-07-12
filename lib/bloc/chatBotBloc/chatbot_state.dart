import 'package:equatable/equatable.dart';

import '../../Model/chat_message.dart';

abstract class ChatBotState extends Equatable {
  final List<ChatMessage> messages;

  const ChatBotState(this.messages);

  @override
  List<Object?> get props => [messages];
}

class ChatBotInitial extends ChatBotState {
  ChatBotInitial() : super(const []);
}

class ChatBotLoading extends ChatBotState {
  const ChatBotLoading(List<ChatMessage> messages) : super(messages);
}

class ChatBotLoaded extends ChatBotState {
  const ChatBotLoaded(List<ChatMessage> messages) : super(messages);
}

class ChatBotError extends ChatBotState {
  final String error;
  const ChatBotError(this.error, List<ChatMessage> messages) : super(messages);

  @override
  List<Object?> get props => [error, ...super.props];
}

