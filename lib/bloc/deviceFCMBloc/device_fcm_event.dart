

import 'package:equatable/equatable.dart';

abstract class DeviceFCMEvent extends Equatable{

  @override
  List<Object?> get props => [];
}


class PostDeviceFcm extends DeviceFCMEvent {
  final String deviceFcmId;

  PostDeviceFcm({required this.deviceFcmId});

  @override
  List<Object?> get props => [deviceFcmId];
}