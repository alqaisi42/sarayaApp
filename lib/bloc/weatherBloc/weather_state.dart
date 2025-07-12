

import 'package:equatable/equatable.dart';
import 'package:newsapp/Model/weather_response.dart';

abstract class WeatherState extends Equatable {

  @override
  List<Object?> get props => [];
}

class WeatherInitialState extends WeatherState {}

class WeatherLoadingState extends WeatherState {}

class WeatherSuccessState extends WeatherState {
  final WeatherResponse weatherData;

  WeatherSuccessState({required this.weatherData});

  @override
  List<Object?> get props => [weatherData];
}


class WeatherErrorState extends WeatherState{
  final String errorMessage;

  WeatherErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}