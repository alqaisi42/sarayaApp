

import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/bloc/deviceFCMBloc/device_fcm_state.dart';

import '../../Model/device_fcm_model.dart';
import '../../config/api_routes.dart';
import '../blocRepository/post_api_repo.dart';
import 'device_fcm_event.dart';

class DeviceFCMBloc extends Bloc<DeviceFCMEvent, DeviceFCMState> {
  final PostapiRepo<DeviceFCMResponse> _postapiRepo;

  DeviceFCMBloc(): _postapiRepo = PostapiRepo<DeviceFCMResponse>(
    fromJson: DeviceFCMResponse.fromJson,
    isToken: true,
  ),
        super(DeviceFCMInitialState()) {
    on<PostDeviceFcm>(_onSendDeviceFCM);
  }

  Future<void> _onSendDeviceFCM(PostDeviceFcm event, Emitter<DeviceFCMState> emit) async {
    emit(DeviceFCMLoadingState());
    log('FCM bloc Token: ${event.deviceFcmId}');
    try {
      final result = await _postapiRepo.postData(storeFcmUrl,fcmId:event.deviceFcmId);
      emit(DeviceFCMSuccessState(fcmData: result));
    } catch (e) {
      emit(DeviceFCMErrorState(errorMessage: e.toString()));
    }
  }
}
