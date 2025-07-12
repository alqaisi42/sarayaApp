// user_data_repo.dart
import 'dart:io';
import 'package:dio/dio.dart';
import '../../config/api_baseurl.dart';
import '../../config/api_routes.dart';


class UserDataRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future<dynamic> postUserData(String url, {required String userName, required File? userProfile,required String userMobileNumber,required String userEmail, isToken }) async {

    try {
      final formData = FormData.fromMap({
        'user_name': userName,
        if (userProfile != null)
          'profile': await MultipartFile.fromFile(userProfile.path),
        'mobile':userMobileNumber,
        'email':userEmail
      });
      return await _apiBaseHelper.postAPICall(updateUserProfileUrl, formData, isToken);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

}
