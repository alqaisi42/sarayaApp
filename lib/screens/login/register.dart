// ignore_for_file: avoid_print, use_key_in_widget_constructors, prefer_const_constructors, use_super_parameters, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:newsapp/config/formvalidation.dart';


import '../../bloc/authBloc/auth_bloc.dart';
import '../../bloc/authBloc/auth_event.dart';
import '../../bloc/authBloc/auth_state.dart';
import '../../config/colors.dart';
import '../../config/constants.dart';

import '../../config/helper/helper_functions.dart';
import '../../config/hiveLocalStorage/hive_storage.dart';
import '../../utils/widgets/custom_textfield.dart';
import '../../utils/widgets/custome_btn.dart';
import '../../utils/widgets/dividerline.dart';
import '../../../l10n/app_localizations.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RegisterForm(),
    );
  }
}

class RegisterForm extends StatefulWidget {


  @override
  RegisterFormState createState() => RegisterFormState();
}

class RegisterFormState extends State<RegisterForm> {
  final hiveStorage = HiveStorage();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _reenterPasswordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFcmtoken();
  }


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _reenterPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccessState) {
          final checkNewUser = state.authResponse.data?.newsUser;
          if(checkNewUser == true){
            GoRouter.of(context).pushNamed("/channelsPreference");
          }else{
            GoRouter.of(context).pushNamed("home");
          }

        } else if (state is AuthErrorState) {
          CustomFloatingSnackBar.showCustomSnackBar(context, state.error, 0);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar:
              AppBar(backgroundColor: Theme.of(context).colorScheme.surface),
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  child:  Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: MediaQueryHelper.screenWidth(context) * 0.04),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: MediaQueryHelper.screenHeight(context) * 0.1),
                            RegisterHeader(),
                            SizedBox(height: 20),
                            MyTextField(
                              label: AppLocalizations.of(context)!.emial,
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value,context) => validateEmail(value,context),
                              obscureText: false,
                            ),
                            SizedBox(height: 16),
                            MyTextField(
                              label: AppLocalizations.of(context)!.name,
                              controller: _nameController,
                              keyboardType: TextInputType.name,
                              validator: (value,context) => validateName(value,context),
                              obscureText: false,
                            ),
                            SizedBox(height: 16),
                            MyTextField(
                              label: AppLocalizations.of(context)!.password,
                              controller: _passwordController,
                              keyboardType: TextInputType.visiblePassword,
                              validator: (value,context) => validatePassword(value,context),
                              obscureText: true,
                            ),
                            SizedBox(height: 16),
                            MyTextField(
                              label: AppLocalizations.of(context)!.reEnterPassword,
                              controller: _reenterPasswordController,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              validator: (value, context) => validateReenterPassword(value, context, _reenterPasswordController),
                            ),

                            SizedBox(height: 24),
                            LoginBtn(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  BlocProvider.of<AuthBloc>(context).add(
                                      CreateAccountEvent(
                                          password: _passwordController.text,
                                          email: _emailController.text,
                                          name: _nameController.text,
                                          fcmId: fcmToken
                                      ));
                                }
                              },
                              isLoading: state is AuthLoadingState && state.loadingType == 'createAccount',
                              btnName: AppLocalizations.of(context)!.createAccount,
                            ),
                            SizedBox(height: MediaQueryHelper.screenHeight(context) * 0.02),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: MediaQueryHelper.screenWidth(context) * 0.01),
                              child: Dividerline(),
                            ),
                            SizedBox(height: MediaQueryHelper.screenHeight(context) * 0.02),
                            GestureDetector(
                              onTap: () {
                                GoRouter.of(context).push("/signin");
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.continueLabel,
                                    style: TextStyle(
                                        fontSize: 14, fontFamily: fontType),
                                  ),
                                  SizedBox(
                                    width: MediaQueryHelper.screenWidth(context) * 0.01,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.withLogin,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: fontType,
                                        color: AppColors().primaryColor,
                                        fontWeight: FontWeight.w500),
                                  ),

                                ],
                              ),
                            ),
                            SizedBox(height: MediaQueryHelper.screenHeight(context) * 0.01),
                            // RegisterWithSocial()

                          ],
                        ),
                      ),
                    ),
                  );

              },
            ),
          ),
        );
      },
    );
  }
}

class RegisterHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset("assets/img/new_logo.png",height:MediaQueryHelper.screenHeight(context) * 0.2,),
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

class RegisterWithSocial extends StatelessWidget {
  const RegisterWithSocial({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQueryHelper.screenWidth(context) * 0.04,
                  vertical: MediaQueryHelper.screenHeight(context) * 0.01),
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: SvgPicture.asset(
              "assets/img/googleicon.svg",
              height: MediaQueryHelper.screenHeight(context) * 0.04,
            )),
        SizedBox(
          width: MediaQueryHelper.screenWidth(context) * 0.04,
        ),
        ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQueryHelper.screenWidth(context) * 0.04,
                  vertical: MediaQueryHelper.screenHeight(context) * 0.01),
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: SvgPicture.asset(
              "assets/img/phone-call2.svg",
              height: MediaQueryHelper.screenHeight(context) * 0.04,
            )),
      ],
    );
  }
}
