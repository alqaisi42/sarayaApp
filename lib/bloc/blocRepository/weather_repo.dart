import 'dart:developer';

import 'package:dio/dio.dart';
import '../../Model/weather_response.dart';
import '../../config/constants.dart';

class WeatherRepository {
  final Dio _dio = Dio();

  Future<WeatherResponse> fetchWeatherData(double lat, double lon) async {
    final String apiUrl = '$weatherBaseUrl?lat=$lat&lon=$lon&appid=$weatherKey';
    try {
      final response = await _dio.get(apiUrl);
      log("weather res $response");
      if (response.statusCode == 200) {
        return WeatherResponse.fromJson(response.data);

      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          message: 'Failed to load weather data',
        );
      }
    } on DioException catch (e) {
      throw Exception('Failed to fetch weather data: ${e.message}');
    }
  }
}