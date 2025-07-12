import 'package:equatable/equatable.dart';
import 'package:newsapp/Model/auth%20model/auth_response_model.dart';

abstract class AuthState extends Equatable {}

class AuthInitialState extends AuthState {
  @override
  List<Object?> get props => [];
}



class AuthLoadingState extends AuthState {
  final String loadingType;

  AuthLoadingState({required this.loadingType});

  @override
  List<Object?> get props => [loadingType];
}

class AuthSuccessState extends AuthState {
  final AuthResponse authResponse;

  AuthSuccessState(this.authResponse,);

  @override
  List<Object?> get props => [authResponse];
}

class AuthErrorState extends AuthState {
  final String error;

  AuthErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}

class AuthTokenState extends AuthState {
  final String userToken;

  AuthTokenState({required this.userToken});

  @override
  List<Object?> get props => [userToken];
}

class LoginPhoneCodeSentState extends AuthState {
  final String? verificationId;

  LoginPhoneCodeSentState({this.verificationId});

  @override
  List<Object?> get props => [verificationId];
}

class LogOutState extends AuthState {
  final String message;

  LogOutState({this.message = ''});

  @override
  List<Object?> get props => [message];
}
