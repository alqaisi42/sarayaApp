import 'package:equatable/equatable.dart';

abstract class LocationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LocationInitial extends LocationState {}


class LocationSuccess extends LocationState {
  final double latitude;
  final double longitude;

  LocationSuccess({required this.latitude, required this.longitude});

  @override
  List<Object?> get props => [latitude, longitude];
}

class LocationFailure extends LocationState {
  final String error;

  LocationFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
