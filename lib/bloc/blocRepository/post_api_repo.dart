import 'dart:convert';
import '../../config/api_baseurl.dart';


class PostapiRepo<T> {
  final T Function(Map<String, dynamic>) fromJson;
  final bool isToken;

  PostapiRepo({required this.fromJson, required this.isToken,});

  Future<List<T>> postData(String url,
      {String? id,
        String? slug,
        String? replyId,
        String? comments,
        String? postID,
        String? email,
        String? report,
        String? reportCommentId,
        String? fcmId,
        String? userMessage,
        String? newsLanguageId,
        String? tenureId,
        String? planId,
        String? planAmount,
        String? razorpayPaymentId,
        String? razorpayOrderId,
        String? razorpaySignature,
      }) async {

    try {
      final response = await ApiBaseHelper().postAPICall(
          url,
          {
            'id': id ?? "",
            'slug': slug ?? "",
            'replay_id': replyId ?? "",
            'comment': comments ?? "",
            'post_id': postID ?? "",
            'email' : email ?? "",
            'report' : report ?? "",
            'reportCommentId' : reportCommentId ?? "",
            'fcmId' : fcmId ?? "",
            'message':userMessage ?? "",
            'news_language_id':newsLanguageId ?? "",
            'tenure_id':tenureId ?? "",
            'amount':planAmount ?? "",
            'plan_id':planId ?? "",
            'razorpay_payment_id':razorpayPaymentId ?? "",
            'razorpay_order_id':razorpayOrderId ?? "",
            'razorpay_signature':razorpaySignature ?? "",
          },
          isToken);

      if (response.statusCode == 200) {
        List<dynamic> jsonList;
        if (response.data is String) {
          jsonList = json.decode(response.data);
        } else if (response.data is Map) {
          jsonList = [response.data];
        } else if (response.data is List) {
          jsonList = response.data;
        } else {
          throw ApiException('Unexpected response format');
        }

        return jsonList.map((json) => fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw ApiException('${response.statusCode}');
      }
    } catch (e) {

      throw ApiException(e.toString());
    }
  }
}



class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}