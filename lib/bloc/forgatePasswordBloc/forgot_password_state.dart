
import 'package:equatable/equatable.dart';

import '../../Model/forgote_password_model.dart';

abstract class ForgatePasswordState extends Equatable {

  @override
  List<Object?> get props => [];
}


class ForgatePasswordInitialState extends ForgatePasswordState {}

class ForgatePasswordLoadingState extends ForgatePasswordState {}

class ForgatePasswordSuccessState extends ForgatePasswordState {
  final ForgatePasswordResponse forgatePasswordData;

  ForgatePasswordSuccessState({required this.forgatePasswordData});


  @override
  List<Object?> get props => [forgatePasswordData];
}

class ForgatePasswordErrorState extends ForgatePasswordState {
  final String errorMessage;

  ForgatePasswordErrorState({required this.errorMessage});


  @override
  List<Object?> get props => [errorMessage];
}