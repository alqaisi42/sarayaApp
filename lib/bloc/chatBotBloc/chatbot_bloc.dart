import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Model/chat_message.dart';
import '../../config/openai/openai_service.dart';
import 'chatbot_event.dart';
import 'chatbot_state.dart';

class ChatBotBloc extends Bloc<ChatBotEvent, ChatBotState> {
  final OpenAIService service;
  final List<ChatMessage> _messages = [];

  ChatBotBloc(this.service) : super(ChatBotInitial()) {
    on<SendChatMessage>(_onSendChatMessage);
  }

  Future<void> _onSendChatMessage(
      SendChatMessage event, Emitter<ChatBotState> emit) async {
    final userMsg = ChatMessage(
      text: event.message,
      isUser: true,
      imagePath: event.image?.path,
    );
    _messages.add(userMsg);
    emit(ChatBotLoading(List.from(_messages)));
    try {
      final response =
          await service.sendMessage(event.message, image: event.image);
      _messages.add(ChatMessage(text: response, isUser: false));
      emit(ChatBotLoaded(List.from(_messages)));
    } catch (e) {
      emit(ChatBotError(e.toString(), List.from(_messages)));
    }
  }
}

