import 'dart:convert';

import '../../config/api_baseurl.dart';





class GetapiRepo<T> {
  final String url;
  final T Function(Map<String, dynamic>) fromJson;
  final bool isToken;

  GetapiRepo({required this.url, required this.fromJson, required this.isToken});

  Future<List<T>> getData() async {
    try {
      // Make the API call

      final response = await ApiBaseHelper().getAPICall(url, {}, isToken);

      // Check for successful status code
      if (response.statusCode == 200) {
        List<dynamic> jsonList;

        // Handle different response formats
        if (response.data is String) {
          // Parse string response to JSON
          jsonList = json.decode(response.data);
        } else if (response.data is Map) {
          // If it's a map, wrap it in a list
          jsonList = [response.data];
        } else if (response.data is List) {
          // If it's already a list, just assign it
          jsonList = response.data;
        } else {
          throw ApiException('Unexpected response format: ${response.data.runtimeType}');
        }

        // Convert the dynamic list to the expected type T using fromJson
        return jsonList.map((json) => fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw ApiException('Failed to load data, status code: ${response.statusCode}');
      }
    } catch (e) {

      throw ApiException('Error fetching data: $e');
    }
  }
}





class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}