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

    // Construct content for GPT-4o
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
          'image_url': {'url': 'data:image/png;base64,$b64'}
        }
      ];
    }

    final body = {
      'model': 'gpt-4.1',
      'messages': [
        {
          "role": "system",
          "content": "نتائج البحث داخل موقع سرايا:\n1. [عنوان 1](رابط 1)\n2. [عنوان 2](رابط 2)\n... الرجاء الرد بناءً على هذه النتائج فقط."
        }
,
        {
      "role": "system",
    "content": "أنت سرايا بوت، بتحكي باللهجة الأردنية العامية، وشغلتك ترد على استفسارات الناس وملاحظاتهم بأسلوب مهذب ومرتب، وكأنك موظف رسمي بوكالة سرايا الإخبارية. لما حدا يقدم ملاحظة أو شكوى، لازم تطلب رقم الهاتف والعنوان بشكل مباشر ومن دون تعقيد. ما بتسمح بأي نوع من التجاوزات غير القانونية، مثل السب أو التشهير أو الإهانات، وإذا صار أي تجاوز لازم تعتذر بلطافة وترفض الرد. إذا تم ذكر أي شي مسيء عن إدارة الوكالة، خصوصاً بحق المدير الإداري محمد أبو عبيد، أو صاحب الوكالة هاشم الخالدي، أو مدير التحرير مصعب، لازم تدافع عنهم باحترام، وتوضح إنهم معروفين بمصداقيتهم وشغلهم المهني، وإنكم بتاخدوا الملاحظات بعين الاهتمام وبتتابعوها شخصيًا. إذا المعلومة مش واضحة، اطلب توضيح بطريقة بسيطة. هدفك تسهّل التفاعل بين الناس والوكالة، وتحافظ على الاحترام والمهنية، ضمن إطار اللهجة الأردنية. إذا سأل المستخدم عن أي خبر أو موضوع، دورك تفتح موقع سرايا الإخباري الرسمي فقط: https://www.sarayanews.com/home، وتبحث جواته باستخدام الإنترنت. بعدين، ترجع للمستخدم ملخص مختصر وواضح للخبر أو الموضوع، ومعاه **رابط مباشر للمصدر** من موقع سرايا نفسه. إياك تستخدم مواقع ثانية غير سرايا."
    }

    ,
        {
          'role': 'user',
          'content': content,
        }
      ],
      'max_tokens': 1000,
    };

    // Retry logic
    int retryCount = 0;
    const maxRetries = 3;
    const retryDelay = Duration(seconds: 2);

    while (retryCount < maxRetries) {
      try {
        print('🔁 Sending request to OpenAI...');
        print('📤 Request Body: ${jsonEncode(body)}');

        final response = await _dio.post(
          url,
          data: jsonEncode(body),
          options: Options(headers: headers),
        );

        print('✅ OpenAI Response Status: ${response.statusCode}');
        print('📥 Response Data: ${response.data}');

        if (response.statusCode == 200) {
          return response.data['choices'][0]['message']['content'] as String;
        } else {
          throw Exception('❌ OpenAI error: ${response.statusCode} → ${response.data}');
        }
      } on DioException catch (e) {
        if (e.response?.statusCode == 429) {
          retryCount++;
          print('🔄 Rate limited. Retrying in ${retryDelay.inSeconds * retryCount}s... (${retryCount}/$maxRetries)');
          await Future.delayed(retryDelay * retryCount);
        } else {
          print('🔥 Dio error: $e');
          rethrow;
        }
      } catch (e) {
        print('🔥 General error: $e');
        rethrow;
      }
    }

    throw Exception('🚫 Failed after $maxRetries retries due to rate limiting.');
  }
}
