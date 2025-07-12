// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, unnecessary_brace_in_string_interps


import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:newsapp/config/colors.dart';
import 'package:newsapp/config/constants.dart';

import 'package:flutter_svg/flutter_svg.dart';

import '../../bloc/authBloc/auth_bloc.dart';
import '../../bloc/authBloc/auth_event.dart';
import '../../bloc/authBloc/auth_state.dart';
import '../../config/formvalidation.dart';

import '../../config/helper/helper_functions.dart';
import '../../config/hiveLocalStorage/hive_storage.dart';
import '../../notification_service.dart';

import '../../utils/widgets/custom_textfield.dart';
import '../../utils/widgets/custome_btn.dart';
import '../../utils/widgets/dividerline.dart';
import '../../../l10n/app_localizations.dart';


class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final FirebaseMessagingService _firebaseMessagingService = FirebaseMessagingService();
  String? _fcmToken;
  final hiveStorage = HiveStorage();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getFcmtoken();
  }


  Future<void> _getFcmtoken() async {



    final token = await _firebaseMessagingService.getToken();
    setState(() {
      _fcmToken = token;
    });
    log('FCM Token: $_fcmToken');

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: MediaQueryHelper.screenWidth(context) * 0.04),
            child: ElevatedButton(
              onPressed: () {
                GoRouter.of(context).pushReplacement("/home");

                },
              style: ElevatedButton.styleFrom(

                foregroundColor: Theme.of(context).colorScheme.brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: AppColors().primaryColor,
                    width: 1,
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(
                AppLocalizations.of(context)!.skip,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: fontType,
                  color: AppColors().primaryColor
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthErrorState) {
            CustomFloatingSnackBar.showCustomSnackBar(context, state.error, 0);
          } else if (state is AuthSuccessState) {
            final   checkNewUser = state.authResponse.data?.newsUser;
            if( checkNewUser ==  true){
              GoRouter.of(context).go("/channelsPreference");
            }else {
              GoRouter.of(context).go("/home");
            }
          }
        },
        builder: (context, state) {
          bool isLoading = state is AuthLoadingState;
          String loadingtype = state is AuthLoadingState ? state.loadingType : "";

          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child:  Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SigninHeader(),
                                Container(
                                  margin: EdgeInsets.only(
                                    left: MediaQueryHelper.screenWidth(context) * 0.04,right: MediaQueryHelper.screenWidth(context) * 0.04,
                                    top: MediaQueryHelper.screenHeight(context) * 0.02,
                                  ),
                                  child: SocialButtons(
                                    imagePath: "assets/img/googleicon.svg",
                                    text: AppLocalizations.of(context)!.logInWithGoogle,
                                    isLoading: loadingtype == "google" && isLoading,
                                    callBack: () {
                                      if (!isLoading) {
                                        context.read<AuthBloc>().add(LoginWIthGoogleEvent(fcmId: _fcmToken.toString()));
                                      }
                                    },
                                  ),
                                ),
                                if (Platform.isAndroid)
                                  SizedBox(height: MediaQueryHelper.screenHeight(context) * 0.02,),
                                if (Platform.isIOS)
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: MediaQueryHelper.screenWidth(context) * 0.04,
                                      right: MediaQueryHelper.screenWidth(context) * 0.04,
                                      top: MediaQueryHelper.screenHeight(context) * 0.02,
                                      bottom: MediaQueryHelper.screenHeight(context) * 0.02,
                                    ),
                                    child: SocialButtons(
                                      imagePath: "assets/img/applelogo.svg",
                                      text: AppLocalizations.of(context)!.logInWithApple,
                                      isLoading: loadingtype == "apple" && isLoading,
                                      callBack: () {
                                        if (!isLoading) {
                                          context.read<AuthBloc>().add(LoginWithAppleEvent(fcmId: _fcmToken.toString()));
                                        }
                                      },
                                    ),
                                  ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: MediaQueryHelper.screenWidth(context) * 0.03,
                                  ),
                                  child: SocialButtons(
                                    imagePath: "assets/img/phone-call.svg",
                                    text: AppLocalizations.of(context)!.logInWithNumber,
                                    callBack: () {
                                      GoRouter.of(context).push("/SignupWithPhoneNumber");
                                    },
                                  ),
                                ),
                                SizedBox(height: MediaQueryHelper.screenHeight(context) * 0.03),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: MediaQueryHelper.screenWidth(context) * 0.04
                                  ),
                                  child: Dividerline(),
                                ),
                                SizedBox(height: MediaQueryHelper.screenHeight(context) * 0.03),
                                LoginForm(
                                  isLoading: isLoading,
                                  loadingtype: loadingtype, fcmToken: _fcmToken.toString(),
                                ),
                                SizedBox(height: MediaQueryHelper.screenHeight(context) * 0.02),
                                ResetPassword(),
                                SizedBox(height: MediaQueryHelper.screenHeight(context) * 0.02),
                                CreatAccount(),
                              ],
                            ),
                          ),

                      ),
                    );
              },
          );
        },
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  final bool isLoading;
  final String loadingtype;
  final String fcmToken;
  const LoginForm(
      {super.key, required this.isLoading, required this.loadingtype,required this.fcmToken});

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: MediaQueryHelper.screenWidth(context) * 0.04),
            child: MyTextField(
              label: AppLocalizations.of(context)!.emial,
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              validator: validateEmail,
              obscureText: false,
            ),
          ),
          SizedBox(
            height: MediaQueryHelper.screenHeight(context) * 0.02,
          ),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: MediaQueryHelper.screenWidth(context) * 0.04),
            child: MyTextField(
              label: AppLocalizations.of(context)!.password,
              controller: passwordController,
              keyboardType: TextInputType.visiblePassword,
              validator: validatePassword,
              obscureText: true,
            ),
          ),
          SizedBox(
            height: MediaQueryHelper.screenHeight(context) * 0.02,
          ),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: MediaQueryHelper.screenWidth(context) * 0.04),
            child: LoginBtn(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  BlocProvider.of<AuthBloc>(context).add(
                    LoginWithEmailEvent(
                      email: emailController.text,
                      password: passwordController.text,
                      fcmToken: widget.fcmToken
                    ),
                  );
                }
              },
              isLoading: widget.loadingtype == "email" && widget.isLoading,
              btnName: AppLocalizations.of(context)!.login,
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

class SigninHeader extends StatelessWidget {
  const SigninHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset("assets/img/logo.png",height:MediaQueryHelper.screenHeight(context) * 0.2,),
        SizedBox(
          height: MediaQueryHelper.screenHeight(context) * 0.01,
        ),
        Text(
          AppLocalizations.of(context)!.signInToNewsHunt,
          style: TextStyle(
              fontSize: 18,
              fontFamily: fontType,
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class SocialButtons extends StatelessWidget {
  final String imagePath;
  final String text;
  final bool isLoading;
  final VoidCallback callBack;

  const SocialButtons({
    super.key,
    required this.imagePath,
    required this.text,
    required this.callBack,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : callBack,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          SvgPicture.asset(
            imagePath,
            height: MediaQueryHelper.screenHeight(context) * 0.03,
          ),
          isLoading
              ? SizedBox(
                  height: MediaQueryHelper.screenHeight(context) * 0.03,
                  width: MediaQueryHelper.screenHeight(context) * 0.03,
                  child: CircularProgressIndicator(
                    color: AppColors().primaryColor,
                    strokeWidth: 2,
                  ),
                )
              : Center(
                  child: Text(
                    text,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: fontType,
                        color: Colors.grey.shade600),
                  ),
                ),
        ],
      ),
    );
  }
}



class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {

        GoRouter.of(context).push('/resetpasswordscreen');
      },
      child: Text(
        AppLocalizations.of(context)!.forgotPassword,
        style: TextStyle(
            fontSize: 14,
            fontFamily: fontType,
            color: AppColors().primaryColor,
            fontWeight: FontWeight.w400),
      ),
    );
  }
}

class CreatAccount extends StatelessWidget {
  const CreatAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.noAccountCreateOne,
          style: TextStyle(
              fontSize: 14,
              fontFamily: fontType,
              fontWeight: FontWeight.w400),
        ),
        GestureDetector(
          onTap: () {


            GoRouter.of(context).push("/register");

          },
          child: Text(
            AppLocalizations.of(context)!.createOne,
            style: TextStyle(
                fontSize: 14,
                fontFamily: fontType,
                color: AppColors().primaryColor,
                fontWeight: FontWeight.w400),
          ),
        )
      ],
    );
  }
}
