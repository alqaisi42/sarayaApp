


import 'package:equatable/equatable.dart';

import '../../Model/device_fcm_model.dart';

abstract class DeviceFCMState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DeviceFCMInitialState extends DeviceFCMState {}

class DeviceFCMLoadingState extends DeviceFCMState {}

class DeviceFCMSuccessState extends DeviceFCMState {
  final List<DeviceFCMResponse> fcmData;

  DeviceFCMSuccessState({required this.fcmData});

  @override
  List<Object?> get props => [fcmData];
}

class DeviceFCMErrorState extends DeviceFCMState {
  final String errorMessage;

  DeviceFCMErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
