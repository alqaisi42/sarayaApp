

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';


import '../../config/helper/helper_functions.dart';
import 'location_coordinated_state.dart';
import 'location_coordinates_event.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationInitial()) {
    on<FetchLocationEvent>(_onFetchLocationEvent);
  }

  Future<void> _onFetchLocationEvent(
      FetchLocationEvent event, Emitter<LocationState> emit) async {
    try {

      Position position = await LocationService().getCurrentLocation();

      // if(event.context.mounted){
      //   event.context.read<WeatherBloc>().add(FetchWeatherData(lat:position.latitude,lon:position.longitude));
      // }
      emit(LocationSuccess(latitude: position.latitude, longitude: position.longitude,));
    } catch (e) {
      emit(LocationFailure(error: e.toString()));
    }
  }
}