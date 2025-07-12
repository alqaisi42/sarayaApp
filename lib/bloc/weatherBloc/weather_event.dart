

import 'package:equatable/equatable.dart';

abstract class WeatherEvent extends Equatable {

  @override
  List<Object?> get props => [];
}



class FetchWeatherData extends WeatherEvent {
final double lat;
final double lon;
final bool reFetch;

FetchWeatherData({required this.lat,required this.lon,this.reFetch = false});

  @override
  List<Object?> get props => [];
}