import 'dart:convert';

import '../../config/api_baseurl.dart';

class DeleteUserRepository<T> {
  final T Function(Map<String, dynamic>) fromJson;
  final bool isToken;

  DeleteUserRepository({required this.fromJson, required this.isToken,});

  Future<List<T>> deleteUser(String url, {int? userDevice}) async {
    try {
      final response = await ApiBaseHelper().deleteAPICall(
        url,
        {},
        isToken,
      );

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

        return jsonList
            .map((json) => fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ApiException('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}