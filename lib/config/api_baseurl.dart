import 'dart:async';

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart' as dio_;


import '../Model/auth model/auth_response_model.dart';
import 'hiveLocalStorage/hive_storage.dart';





class ApiException implements Exception {
  ApiException(this.errorMessage);

  String errorMessage;

  @override
  String toString() {
    return errorMessage;
  }
}


Future<String?> _getAuthToken() async {
  final AuthResponse? authResponse = await HiveStorage().getToken();
  String? token = authResponse?.data?.token;
  return token;
}

Future<String?> _getNewsLanguageId() async {
  final selectedLanguages = await HiveStorage().getSelectedLanguages();

  if (selectedLanguages.isEmpty) return '';

  final ids = selectedLanguages
      .map((lang) => lang['id'])
      .where((id) => id != null)
      .join(',');

  return ids;
}


Future<Map<String, String>> getHeaders(bool isToken) async {
  final String? token = await _getAuthToken();
  String? newsLanguageId = await _getNewsLanguageId();


  if(newsLanguageId == ''){
    newsLanguageId = '';
  }


  if (token != null  && isToken) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'news_language_id':newsLanguageId.toString()
    };
  }
  return {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'news_language_id':newsLanguageId.toString()
  };
}

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();




class ApiBaseHelper {
  static const int timeOut = 60;







  void handleDioErrorException(dio_.DioException e) {
    if (e.response != null) {
      // Handle response-based errors
      switch (e.response?.statusCode) {
        case 401:
          throw ApiException(e.response?.data?['message']);
        case 403:
          throw ApiException('${e.response?.data?['message']}');
        case 203:
          throw ApiException('${e.response?.data?['message']}');
        case 429:
          throw ApiException('${e.response?.data?['message']}');
        case 422:
          if (e.response?.data?['errors'] is Map) {
            final emailErrors = e.response?.data['errors']['email'];
            throw ApiException(emailErrors is List ? emailErrors.first : (emailErrors));
          }
          throw ApiException('Validation error');
        case 500:
        case 503:
          throw ApiException(e.response?.data?['message']);
        default:
          throw ApiException(e.response?.data?['message']);
      }
    } else {
      // Handle network-level errors or unexpected errors
      switch (e.type) {
        case dio_.DioExceptionType.connectionTimeout:
          throw ApiException('Connection timeout. Check your internet.');
        case dio_.DioExceptionType.receiveTimeout:
          throw ApiException('Receive timeout. Please try again.');
        case dio_.DioExceptionType.sendTimeout:
          throw ApiException('Send timeout. Please check your connection.');
        case dio_.DioExceptionType.unknown:
          throw ApiException('Network error. Unable to connect.');
        default:
          throw ApiException('${e.message}');
      }
    }
  }

  Future<void> downloadFile({
    required String url,
    required dio_.CancelToken cancelToken,
    required String savePath,
    required Function updateDownloadedPercentage,
  }) async {
    try {
      final dio_.Dio dio = dio_.Dio();
      await dio.download(url, savePath, cancelToken: cancelToken,
          onReceiveProgress: ((count, total) {
            updateDownloadedPercentage((count / total) * 100);
          }));
    } on dio_.DioException catch (e) {
      handleDioErrorException(e);
    } catch (e) {
      throw Exception('Failed to download file');
    }
  }

  Future<dynamic> postAPICall(String url, dynamic params, isToken) async {
   late dio_.Response responseJson;
    final dio_.Dio dio = dio_.Dio();
    final headers = await getHeaders(isToken);
    try {
      final response = await dio.post(
        url,
        data: params,
        options: dio_.Options(
          headers: headers,
        ),
      );

      if (kDebugMode) {
        print('Response from API ($url): ${response.statusCode} - ${response.data}');
      }

      responseJson = response;
    } on dio_.DioException catch (e) {
      handleDioErrorException(e);
    } catch (e) {
      throw ApiException('An unexpected error occurred');
    }

    return responseJson;
  }

  Future<dynamic> deleteAPICall(String url, dynamic params, isToken) async {
    late dio_.Response responseJson;
    final dio_.Dio dio = dio_.Dio();
    final headers = await getHeaders(isToken);

    // Remove Content-Length header if it exists
    headers.remove('content-length');

    try {
      final response = await dio.delete(
        url,
        data: params,
        options: dio_.Options(
          headers: headers,
          // Prevent Dio from adding Content-Length header
          contentType: null,
        ),
      );

      if (kDebugMode) {
        print('Response from API ($url): ${response.statusCode} - ${response.data}');
      }

      responseJson = response;
    } on dio_.DioException catch (e) {
      handleDioErrorException(e);
    } catch (e) {
      throw ApiException('An unexpected error occurred');
    }

    return responseJson;
  }


  Future<dynamic> getAPICall(String url, dynamic params, bool isToken) async {
    final dio_.Dio dio = dio_.Dio();
    final headers = await getHeaders(isToken);

    try {
      final response = await dio.get(
        url,
        queryParameters: (params != null && params.isNotEmpty) ? params : null,
        options: dio_.Options(headers: headers),
      );

      if (kDebugMode) {
        print(
            'response api****$url*****************${response.statusCode}*********${response.data}');
      }

      if (response.data != null) {
        return response;
      } else {
        throw ApiException('No data found in the response');
      }
    } on dio_.DioException catch (e) {
      handleDioErrorException(e);
    } catch (e) {
      throw ApiException('An unexpected error occurred');
    }
  }

  Future<dynamic> firebaseTokenSend(Uri url, String firebaseToken,String fcmId) async {
    dynamic responseJson;
    final dio_.Dio dio = dio_.Dio();
    try {
      final response = await dio
          .post(
        url.toString(),
        data: {
          'token': firebaseToken,
          'fcm_id':fcmId
        },
        options: dio_.Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      )
          .timeout(const Duration(seconds: ApiBaseHelper.timeOut));

      responseJson = response.data;
    } on SocketException {
      throw ApiException('No Internet connection');
    } on TimeoutException {
      throw ApiException('Something went wrong, Server not Responding');
    } on dio_.DioException catch (e) {
      handleDioErrorException(e);
    } catch (e) {
      throw ApiException('Something Went wrong with ${e.toString()}');
    }

    return responseJson;
  }

  Future<dynamic> createAccount(Uri url, String name, String email, String password,String fcmToken) async {
    dynamic responseJson;
    final dio_.Dio dio = dio_.Dio();

    try {
      final response = await dio.post(
        url.toString(),
        options: dio_.Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        data: {
          "name": name,
          'email': email,
          'password': password,
          'password_confirmation': password,
          'fcm_id':fcmToken
        },
      );

      if (kDebugMode) {
        print(
            'response api****${url.toString()}***************${response.statusCode}*********${response.data}');
      }

      responseJson = response.data;
    } on dio_.DioException catch (e) {
      handleDioErrorException(e);
    } catch (e) {
      throw ApiException('An unexpected error occurred');
    }

    return responseJson;
  }

  Future<dynamic> loginUser(Uri url, String email, String password,String fcmId) async {
    final dio_.Dio dio = dio_.Dio();

    try {
      final response = await dio.post(
        url.toString(),
        options: dio_.Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        data: {
          'email': email,
          'password': password,
          'fcm_id':fcmId
        },
      );

      return response.data;
    } on dio_.DioException catch (e) {
      handleDioErrorException(e);
    } catch (e) {
      throw ApiException('An unexpected error occurred');
    }
  }
}

