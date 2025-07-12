import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

abstract class AuthEvent extends Equatable {}

// // LOGIN WITH EMAIL & PASSWORD ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
class LoginWithEmailEvent extends AuthEvent {
  final String email;
  final String password;
  final String? fcmToken;

  LoginWithEmailEvent({required this.email, required this.password,this.fcmToken});
  @override
  List<Object> get props => [email, password];
}

class CreateAccountEvent extends AuthEvent {
  final String email;
  final String name;
  final String password;
  final String? fcmId;

  CreateAccountEvent({
    required this.email,
    required this.name,
    required this.password,
    this.fcmId
  });

  @override
  List<Object?> get props => [email, name, password];
}

// // LOGIN WITH Gmail~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
class LoginWIthGoogleEvent extends AuthEvent {
final  String fcmId;

  LoginWIthGoogleEvent({required this.fcmId});

  @override
  List<Object?> get props => [fcmId];
}

// // LOGIN WITH Apple~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
class LoginWithAppleEvent extends AuthEvent {
  final  String fcmId;

  LoginWithAppleEvent({required this.fcmId});

  @override
  List<Object?> get props => [fcmId];
}


// // LOGIN WITH Number~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
class SendOtpToPhoneEvent extends AuthEvent {
  final String number;
  final String fcmId;

  SendOtpToPhoneEvent({required this.number,required this.fcmId});

  @override
  List<Object?> get props => [number,fcmId];
}

class PhoneOtpSendEvent extends AuthEvent {
  final String verificationId;
  final int? resendToken;

  PhoneOtpSendEvent({required this.verificationId, this.resendToken});

  @override
  List<Object?> get props => [verificationId, resendToken];
}

class VerifySentOtpEvent extends AuthEvent {
  final String otpCode;
  final String verificationId;
  final BuildContext context;
  final String fcmId;

  VerifySentOtpEvent( {required this.otpCode, required this.verificationId,required this.context,required this.fcmId});
  @override
  List<Object?> get props => [otpCode, verificationId];
}

class PhoneAuthErrorEvent extends AuthEvent {
  final String error;

  PhoneAuthErrorEvent({required this.error});

  @override
  List<Object?> get props => [error];
}

class PhoneAuthVerificationCompletedEvent extends AuthEvent {
  final AuthCredential credential;
  final String fcmId;

  PhoneAuthVerificationCompletedEvent({required this.credential,required this.fcmId});
  @override
  List<Object?> get props => [credential];
}

class ResendOtpEvent extends AuthEvent {

  @override
  List<Object?> get props => [];
}


class LogOutRequestEvent extends AuthEvent {
  final BuildContext context;

  LogOutRequestEvent( {required this.context});

  @override
  List<Object?> get props => [context];
}


