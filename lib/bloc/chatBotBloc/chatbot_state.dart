import 'package:equatable/equatable.dart';
import '../../Model/chat_message.dart';

abstract class ChatBotState extends Equatable {
  final List<ChatMessage> messages;
  final String? partialResponse;

  const ChatBotState(this.messages, {this.partialResponse});

  @override
  List<Object?> get props => [messages, partialResponse];
}

class ChatBotInitial extends ChatBotState {
  const ChatBotInitial() : super(const []);
}

class ChatBotLoading extends ChatBotState {
  const ChatBotLoading(List<ChatMessage> messages, {String? partial})
      : super(messages, partialResponse: partial);
}

class ChatBotLoaded extends ChatBotState {
  const ChatBotLoaded(List<ChatMessage> messages) : super(messages);
}

class ChatBotError extends ChatBotState {
  final String error;
  const ChatBotError(this.error, List<ChatMessage> messages)
      : super(messages);

  @override
  List<Object?> get props => [error, ...super.props];
}
