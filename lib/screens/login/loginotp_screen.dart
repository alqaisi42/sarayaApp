// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/authBloc/auth_bloc.dart';
import '../../bloc/authBloc/auth_event.dart';
import '../../bloc/authBloc/auth_state.dart';
import '../../../l10n/app_localizations.dart';

import '../../config/colors.dart';
import '../../config/constants.dart';

import '../../config/helper/helper_functions.dart';
import '../../config/hiveLocalStorage/hive_storage.dart';
import '../../notification_service.dart';


class Loginotpscreen extends StatefulWidget {

  const Loginotpscreen({super.key, });

  @override
  LoginotpscreenState createState() => LoginotpscreenState();
}

class LoginotpscreenState extends State<Loginotpscreen> {
  final hiveStorage = HiveStorage();
  String? _code;
  bool _onEditing = true;
  int _resendCodeTime = 60;
  late Timer _timer;
  String? verificationId;
  final FirebaseMessagingService _firebaseMessagingService = FirebaseMessagingService();
  String? _fcmToken;





  @override
  void initState() {
    super.initState();
    _startResendTimer();
    _getFcmtoken();


  }


  Future<void> _getFcmtoken() async {



    final token = await _firebaseMessagingService.getToken();
    setState(() {
      _fcmToken = token;
    });
    log('FCM Token: $_fcmToken');

  }


  void _startResendTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCodeTime == 0) {
        _timer.cancel();
      } else {
        setState(() {
          _resendCodeTime--;
        });
      }
    });
  }

  void _resendCode() {
    BlocProvider.of<AuthBloc>(context).add(
      SendOtpToPhoneEvent(number: userMobileNumber, fcmId: fcmToken),
    );

    setState(() {
      _resendCodeTime = 60;
    });

    _startResendTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.otpVerification,
            style: TextStyle(fontFamily: fontType, fontSize: 22),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: Image.asset("assets/img/enterotp.png")
                ),
                SizedBox(height: 20.0),
                VerificationCode(
                  itemSize: 40,

                  margin: EdgeInsets.only(left: 10.0),
                  autofocus: true,
                  fullBorder: true,
                  digitsOnly: true,
                  keyboardType: TextInputType.number,
                  underlineColor: AppColors().primaryColor,

                  length: 6,
                  cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
                  textStyle: const TextStyle(
                    fontFamily: fontType,
                    fontSize: 15,
                  ),

                  onCompleted: (String value) {
                    setState(() {
                      _code = value;
                    });
                  },

                  onEditing: (bool value) {
                    setState(() {
                      _onEditing = false;
                    });
                    if (!_onEditing) FocusScope.of(context).unfocus();
                  },
                ),
                SizedBox(height: 15.0),
                Container(
                  width: double.infinity,
                  child: Center(
                    child: _resendCodeTime == 0
                        ? TextButton(
                            onPressed: _resendCode,
                            child: Text(
                              AppLocalizations.of(context)!.resendCode,
                              style: TextStyle(
                                fontFamily: fontType,
                                fontSize: 15,
                                color: Colors.red,
                              ),
                            ),
                          )
                        : Text(
                            '${AppLocalizations.of(context)!.resendCodeIn} ${_resendCodeTime ~/ 60}:${(_resendCodeTime % 60).toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontFamily: fontType,
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthErrorState) {
                      CustomFloatingSnackBar.showCustomSnackBar(context, AppLocalizations.of(context)!.authenticationFailed, 0);
                    } else if (state is AuthSuccessState) {
                      final checkNewUser = state.authResponse.data?.newsUser;

                      if(checkNewUser == true){
                        GoRouter.of(context).push("/channelsPreference");
                      }else {
                        context.goNamed("home");
                      }


                    } else if (state is LoginPhoneCodeSentState) {
                      verificationId = state.verificationId;
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: ElevatedButton(
                      onPressed: _code != null
                          ? () {


                              // BlocProvider.of<AuthBloc>(context).add(
                              //   VerifySentOtpEvent(
                              //     otpCode: prefilledOtp,
                              //     verificationId: verificationId ?? '',
                              //     context: context, fcmId: _fcmToken.toString(),
                              //   ),
                              // );
                      }
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        backgroundColor: AppColors().primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.continueLabel,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: fontType,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  }
}
