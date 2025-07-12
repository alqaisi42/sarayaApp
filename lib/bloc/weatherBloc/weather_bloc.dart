




import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/bloc/weatherBloc/weather_event.dart';
import 'package:newsapp/bloc/weatherBloc/weather_state.dart';
import '../../Model/weather_response.dart';
import '../blocRepository/weather_repo.dart';


// class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
//   final WeatherRepository repository;
//
//   WeatherBloc({required this.repository}) : super(WeatherInitialState()) {
//     on<FetchWeatherData>(_onFetchWeatherData);
//   }
//
//   Future<void> _onFetchWeatherData(
//       FetchWeatherData event, Emitter<WeatherState> emit) async {
//     log("call api bloc ${event.lon} ${event.lat}");
//     try {
//       if(!event.reFetch){
//         emit(WeatherLoadingState());
//       }
//       final weatherData = await repository.fetchWeatherData(
//         event.lat,
//         event.lon,
//       );
//
//       emit(WeatherSuccessState(weatherData: weatherData));
//     } catch (e) {
//
//       emit(WeatherErrorState(e.toString()));
//     }
//   }
// }

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository repository;
  WeatherResponse? _cachedWeatherData;

  WeatherBloc({required this.repository}) : super(WeatherInitialState()) {
    on<FetchWeatherData>(_onFetchWeatherData);
  }

  Future<void> _onFetchWeatherData(FetchWeatherData event, Emitter<WeatherState> emit) async {
    log("call api bloc ${event.lon} ${event.lat}");

    // If the data is cached and not a re-fetch, return the cached data
    if (_cachedWeatherData != null && !event.reFetch) {
      emit(WeatherSuccessState(weatherData: _cachedWeatherData!));
      return;
    }

    // Show loading state if the data is empty or on re-fetch
    emit(WeatherLoadingState());

    try {
      // Fetch new data from the repository
      final weatherData = await repository.fetchWeatherData(event.lat, event.lon);

      // Cache the fetched data
      _cachedWeatherData = weatherData;

      emit(WeatherSuccessState(weatherData: weatherData));
    } catch (e) {
      emit(WeatherErrorState(e.toString()));
    }
  }
}
