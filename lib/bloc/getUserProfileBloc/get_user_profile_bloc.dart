
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Model/auth model/auth_response_model.dart';

import '../../config/api_routes.dart';

import '../../config/hiveLocalStorage/hive_storage.dart';
import '../blocRepository/get_api_repo.dart';
import 'get_user_profile_event.dart';
import 'get_user_profile_state.dart';



class GetUserProfileBloc extends Bloc<GetUserProfileEvent, GetUserProfileState> {
  final hiveStorage = HiveStorage();


  GetUserProfileBloc()
      : super(GetUserProfileInitialState()) {
    on<FetchUserProfile>(_onFetchUserProfile);
  }


  String? usersProfileImage(){
    if(state is GetUserProfileSuccessState){
      return (state as GetUserProfileSuccessState).userProfileResponse[0].data!.user!.profile;
    }
    return '';
  }


  Future<void> _onFetchUserProfile(FetchUserProfile event, Emitter<GetUserProfileState> emit) async {
    try {
      AuthResponse? existingAuthResponse = await hiveStorage.getToken();


      List<AuthResponse> userProfileRes = await GetapiRepo(
        url: getUserProfileUrl,
        fromJson: AuthResponse.fromJson,
        isToken: true,
      ).getData();


      if (userProfileRes.isNotEmpty && userProfileRes[0].error == false) {

        if (existingAuthResponse != null && existingAuthResponse.data != null && userProfileRes[0].data?.user != null) {
          existingAuthResponse.data!.user!.name = userProfileRes[0].data!.user!.name ?? existingAuthResponse.data!.user!.name;

          existingAuthResponse.data!.user!.email = userProfileRes[0].data!.user!.email ?? existingAuthResponse.data!.user!.email;

          existingAuthResponse.data!.user!.mobile = userProfileRes[0].data!.user!.mobile ?? existingAuthResponse.data!.user!.mobile;

          existingAuthResponse.data!.user!.profile = userProfileRes[0].data!.user!.profile ?? existingAuthResponse.data!.user!.profile;








          await hiveStorage.storeToken(existingAuthResponse);
        } else if (userProfileRes[0].data != null) {
          await hiveStorage.storeToken(userProfileRes[0]);
        }




        emit(GetUserProfileSuccessState(userProfileResponse: userProfileRes));
      } else {
        emit(GetUserProfileErrorState(
            errorMessage: userProfileRes[0].message ?? "Failed to fetch profile"
        ));
      }
    } catch(e) {
      emit(GetUserProfileErrorState(errorMessage: e.toString()));
    }
  }
}