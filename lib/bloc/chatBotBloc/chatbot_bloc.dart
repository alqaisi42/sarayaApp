import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Model/chat_message.dart';
import '../../config/openai/openai_service.dart';
import '../../screens/chatbot/chatbot_screen.dart';
import 'chatbot_event.dart';
import 'chatbot_state.dart';

class ChatBotBloc extends Bloc<ChatBotEvent, ChatBotState> {
  final OpenAIService service;
  final List<ChatMessage> _messages = [];


  ChatBotBloc(this.service) : super(ChatBotInitial()) {
    on<SendChatMessage>(_onSendChatMessage);
    on<AddBotWelcomeMessage>(_onAddBotWelcomeMessage);
    on<ClearChatMessages>((event, emit) {
      _messages.clear();
      emit(ChatBotLoaded(List.from(_messages)));
    });

  }

  Future<void> _onAddBotWelcomeMessage(
      AddBotWelcomeMessage event, Emitter<ChatBotState> emit) async {
    // Avoid duplicate if already added
    final alreadyExists = _messages.any(
          (msg) => !msg.isUser && msg.text == event.message,
    );

    if (!alreadyExists) {
      _messages.insert(
        0,
        ChatMessage(text: event.message, isUser: false),
      );
      emit(ChatBotLoaded(List.from(_messages)));
    }
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



class AddBotWelcomeMessage extends ChatBotEvent {
  final String message;

  const AddBotWelcomeMessage(this.message);

  @override
  List<Object?> get props => [message];
}

