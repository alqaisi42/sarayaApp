

import 'package:equatable/equatable.dart';

import '../../Model/update_user_profile.dart';

abstract class UpdateUserProfileState extends Equatable{

  @override
  List<Object?> get props => [];
}


class UpdateUserProfileInitialState extends UpdateUserProfileState {}

class UpdateUserProfileLoadingState extends UpdateUserProfileState {}

class UpdateUserProfileSuccessState extends UpdateUserProfileState {
  final UpdateProfileResponse updatedUserProfile;

  UpdateUserProfileSuccessState({required this.updatedUserProfile});

  @override
  List<Object?> get props => [updatedUserProfile];
}


class UpdateUserProfileErrorState extends UpdateUserProfileState {
  final String errorMessage;

  UpdateUserProfileErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}