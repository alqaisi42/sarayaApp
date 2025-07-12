

import 'dart:io';


import 'package:equatable/equatable.dart';

abstract class UpdateUserProfile extends Equatable{

  @override
  List<Object?> get props => [];
}

class UpdateUserProfileEvent extends UpdateUserProfile{
  final String userName;
  final File? userProfile;
  final String? userMobileNumber;
  final String? userEmail;

  UpdateUserProfileEvent({required this.userName,required this.userProfile,required this.userEmail, required this.userMobileNumber});

  @override
  List<Object?> get props => [userName,userProfile];
}