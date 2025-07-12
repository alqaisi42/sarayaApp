

import 'package:equatable/equatable.dart';

import '../../Model/delete_user_model.dart';



abstract class DeleteUserState extends Equatable {

  @override
  List<Object?> get props => [];
}

class DeleteUserInitialState extends DeleteUserState {}

class DeleteUserLoadingState extends DeleteUserState {}

class DeleteUserSuccess extends DeleteUserState {
  final DeleteUserResponse userDeleteData;

  DeleteUserSuccess({required this.userDeleteData});


  @override
  List<Object?> get props => [userDeleteData];
}


class DeleteUserErrorState extends DeleteUserState {
  final String errorMessage;

  DeleteUserErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}