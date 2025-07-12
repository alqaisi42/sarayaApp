





import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';


import '../../Model/get_settings_model.dart';
import '../../config/api_routes.dart';
import '../blocRepository/get_api_repo.dart';
import 'get_settings_event.dart';
import 'get_settings_state.dart';


// class GetSettingsBloc extends Bloc<GetSettingsEvent, GetSettingsState> {
//   GetSettingsBloc() : super(GetSettingsInitialState()) {
//     on<FetchGetSettings>(_onFetchGetSettings);
//   }
//
//   Future<void> _onFetchGetSettings(FetchGetSettings event,Emitter<GetSettingsState> emit ) async {
//     try{
//       List<GetSettingsResponse> getSettingsArr = await GetapiRepo(
//         url: getSettingUrl,
//         fromJson: GetSettingsResponse.fromJson, isToken: false,
//       ).getData();
//
//       emit(GetSettingsSuccessState(getSettingsData: getSettingsArr));
//     }catch(e){
//       emit(GetSettingsErrorState(errorMessage: e.toString()));
//     }
//   }
//
// }

class GetSettingsBloc extends Bloc<GetSettingsEvent, GetSettingsState> {
  GetSettingsBloc() : super(GetSettingsInitialState()) {
    on<FetchGetSettings>(_onFetchGetSettings);
  }

  Future<void> _onFetchGetSettings(FetchGetSettings event, Emitter<GetSettingsState> emit) async {
    log('[DEBUG] Entered _onFetchGetSettings handler');
    emit(GetSettingsLoadingState());

    try {
      List<GetSettingsResponse> getSettingsArr = await GetapiRepo(
        url: getSettingUrl,
        fromJson: GetSettingsResponse.fromJson,
        isToken: false,
      ).getData();

      log('[DEBUG] Settings fetched: ${getSettingsArr.length} items');
      emit(GetSettingsSuccessState(getSettingsData: getSettingsArr));
    } catch (e) {
      log('[ERROR] GetSettingsBloc: $e');
      emit(GetSettingsErrorState(errorMessage: e.toString()));
    }
  }


  String? freeTrialPostLimit() {
    // Always return "-1" to simulate unlimited post access
    return "-1";
  }

  String? freeTrialStoryLimit() {
    // Always return "-1" to simulate unlimited story access
    return "-1";
  }

  // String? freeTrialPostLimit() {
  //   if (state is GetSettingsSuccessState) {
  //     final settings = (state as GetSettingsSuccessState).getSettingsData[0];
  //     try {
  //       return settings.data?.firstWhere((setting) => setting.name == 'free_trial_post_limit',).value;
  //     } catch (e) {
  //       return null;
  //     }
  //   }
  //   return null;
  // }
  //
  //
  //
  // String? freeTrialStoryLimit() {
  //   if (state is GetSettingsSuccessState) {
  //     final settings = (state as GetSettingsSuccessState).getSettingsData[0];
  //     try {
  //       return settings.data?.firstWhere((setting) => setting.name == 'free_trial_story_limit',).value;
  //     } catch (e) {
  //       return e.toString();
  //     }
  //   }
  //   return "No Post Limit";
  // }
}