


import 'package:equatable/equatable.dart';

import '../../Model/auth model/auth_response_model.dart';

abstract class GetUserProfileState extends Equatable {

  @override
  List<Object?> get props => [];
}

class GetUserProfileInitialState extends GetUserProfileState {}

class GetUserProfileSuccessState extends GetUserProfileState {
 final List<AuthResponse> userProfileResponse;

 GetUserProfileSuccessState({required this.userProfileResponse});

 @override
 List<Object?> get props => [userProfileResponse];
}

class GetUserProfileErrorState extends GetUserProfileState {
 final String errorMessage;

  GetUserProfileErrorState({required this.errorMessage});


  @override
  List<Object?> get props => [errorMessage];
}