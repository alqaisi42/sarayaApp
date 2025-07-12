import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class ChatBotEvent extends Equatable {
  const ChatBotEvent();

  @override
  List<Object?> get props => [];
}

class SendChatMessage extends ChatBotEvent {
  final String message;
  final File? image;

  const SendChatMessage(this.message, {this.image});

  @override
  List<Object?> get props => [message, image?.path];
}

