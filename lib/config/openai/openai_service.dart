import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../constants.dart';

class OpenAIService {
  final Dio _dio = Dio();

  Future<String> sendMessage(String message, {File? image}) async {
    const url = 'https://api.openai.com/v1/chat/completions';
    final headers = {
      'Authorization': 'Bearer $openAIApiKey',
      'Content-Type': 'application/json',
    };

    dynamic content;
    if (image == null) {
      content = message;
    } else {
      final bytes = await image.readAsBytes();
      final b64 = base64Encode(bytes);
      content = [
        {'type': 'text', 'text': message},
        {
          'type': 'image_url',
          'image_url': {'url': 'data:image/png;base64,' + b64}
        }
      ];
    }

    final body = {
      'model': 'gpt-4o',
      'messages': [
        {
          'role': 'user',
          'content': content,
        }
      ]
    };

    final response = await _dio.post(
      url,
      data: jsonEncode(body),
      options: Options(headers: headers),
    );

    if (response.statusCode == 200) {
      return response.data['choices'][0]['message']['content'] as String;
    }
    throw Exception('Failed to get response: ' + response.statusCode.toString());
  }
}

