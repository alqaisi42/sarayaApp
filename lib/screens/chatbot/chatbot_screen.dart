import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../Model/chat_message.dart';
import '../../bloc/chatBotBloc/chatbot_bloc.dart';
import '../../bloc/chatBotBloc/chatbot_event.dart';
import '../../bloc/chatBotBloc/chatbot_state.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _image;

  Future<void> _pickImage() async {
    final XFile? picked =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty && _image == null) return;
    context.read<ChatBotBloc>().add(SendChatMessage(text, image: _image));
    _controller.clear();
    setState(() {
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saraya Bot')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatBotBloc, ChatBotState>(
                builder: (context, state) {
                  final msgs = state.messages;
                  return ListView.builder(
                    itemCount: msgs.length,
                    itemBuilder: (context, index) {
                      final m = msgs[index];
                      return Align(
                        alignment:
                            m.isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: m.isUser
                                ? Colors.blueAccent
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (m.imagePath != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Image.file(File(m.imagePath!), height: 100),
                                ),
                              Text(
                                m.text,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            if (_image != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.file(_image!, height: 80),
              ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.photo),
                  onPressed: _pickImage,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Ask something...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _send,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

