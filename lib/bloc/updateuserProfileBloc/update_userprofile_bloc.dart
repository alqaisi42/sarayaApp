





import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/bloc/updateuserProfileBloc/update_userprofile_event.dart';
import 'package:newsapp/bloc/updateuserProfileBloc/update_userprofile_state.dart';


import '../../Model/update_user_profile.dart';
import '../../config/api_routes.dart';
import '../blocRepository/user_update_repo.dart';




class UpdateUserProfileBloc extends Bloc<UpdateUserProfileEvent, UpdateUserProfileState> {
  final UserDataRepo _userDataRepo;

  UpdateUserProfileBloc() : _userDataRepo = UserDataRepo(), super(UpdateUserProfileInitialState()) {
    on<UpdateUserProfileEvent>(_postUpdateUserProfile);
  }

  Future<void> _postUpdateUserProfile(UpdateUserProfileEvent event, Emitter<UpdateUserProfileState> emit) async {
    emit(UpdateUserProfileLoadingState());
    try {
      final result = await _userDataRepo.postUserData(
        updateUserProfileUrl,
        userName: event.userName,
        userProfile: event.userProfile,
        userMobileNumber:event.userMobileNumber.toString(),
        userEmail:event.userEmail.toString(),
        isToken: true,
      );

      final UpdateProfileResponse res = UpdateProfileResponse.fromJson(result.data);
      emit(UpdateUserProfileSuccessState(updatedUserProfile: res));
    } catch (e) {

      emit(UpdateUserProfileErrorState(errorMessage: e.toString()));
    }
  }
}